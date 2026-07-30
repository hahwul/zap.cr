module Zap
  class Error < Exception; end

  # Raised when ZAP returns a non-2xx response. The exception message
  # deliberately contains only the status code and request path — never
  # the response body. ZAP error bodies frequently echo the offending
  # request parameters, which on calls like
  # `Api::Network.set_proxy_chain_password` or
  # `Api::Network.add_pkcs12_client_certificate` would otherwise embed a
  # secret into any log line that prints the exception.
  #
  # Callers that need the body (e.g. for diagnostics in a controlled
  # environment) can read it from `#body`. Treat that string as
  # potentially containing secrets that the caller passed in.
  class HttpError < Error
    getter status_code : Int32
    getter path : String?
    getter body : String?

    def initialize(@status_code : Int32, @path : String? = nil, @body : String? = nil)
      msg = String.build do |io|
        io << "HTTP " << @status_code
        if p = @path
          io << " for " << p
        end
      end
      super(msg)
    end
  end

  class Client
    # `base_url` and the timeouts are read-only: the shared `HTTP::Client`
    # (`@http`) is memoized from them on first use, so mutating them after
    # construction would silently have no effect. Build a new `Client` if you
    # need a different daemon URL or timeouts. `api_key` stays mutable because
    # it is read per request and does not feed the memoized connection.
    getter base_url : String
    property api_key : String
    getter connect_timeout : Time::Span
    getter read_timeout : Time::Span

    @http : HTTP::Client?
    # Path prefix taken from `base_url`, resolved alongside `@http`. Empty for
    # the usual root-mounted daemon.
    @base_path : String = ""
    # Serializes request execution through the shared `HTTP::Client`. Crystal's
    # HTTP::Client is not safe for overlapping use from multiple fibers, and a
    # single memoized instance is shared by every API component, so concurrent
    # component calls / concurrent scans could otherwise interleave on the wire
    # and corrupt responses. Single-fiber behavior is unchanged.
    @request_mutex = Mutex.new

    # Daemon URL used when neither an argument nor `ZAP_URL` supplies one.
    DEFAULT_BASE_URL = "http://localhost:8080"

    # `base_url` / `api_key` default to `nil`, meaning "not supplied" — that is
    # the only state in which the `ZAP_URL` / `ZAP_API_KEY` environment
    # fallbacks apply. Passing a value always wins, even when it happens to
    # equal the built-in default.
    def initialize(
      base_url : String? = nil,
      api_key : String? = nil,
      @connect_timeout : Time::Span = 30.seconds,
      @read_timeout : Time::Span = 300.seconds,
    )
      # ENV fallback: when an explicit value is not supplied, fall back to
      # ZAP_URL / ZAP_API_KEY so the daemon location can be configured from the
      # environment (as documented in the README). An env var set to the empty
      # string counts as unset.
      @base_url = base_url || env_value("ZAP_URL") || DEFAULT_BASE_URL
      @api_key = api_key || env_value("ZAP_API_KEY") || ""
    end

    private def env_value(name : String) : String?
      value = ENV[name]?
      value unless value.nil? || value.empty?
    end

    # API components (lazily cached)
    macro api_component(name, type)
      @_{{ name.id }} : {{ type }}?

      def {{ name.id }} : {{ type }}
        @_{{ name.id }} ||= {{ type }}.new(self)
      end
    end

    api_component core, Api::Core
    api_component spider, Api::Spider
    api_component ajax_spider, Api::AjaxSpider
    api_component ascan, Api::Ascan
    api_component pscan, Api::Pscan
    api_component alert, Api::Alert
    api_component alert_filter, Api::AlertFilter
    api_component context, Api::Context
    api_component authentication, Api::Authentication
    api_component authorization, Api::Authorization
    api_component forced_user, Api::ForcedUser
    api_component http_sessions, Api::HttpSessions
    api_component users, Api::Users
    api_component script, Api::Script
    api_component network, Api::Network
    api_component openapi, Api::OpenApi
    api_component stats, Api::Stats
    api_component session_management, Api::SessionManagement
    api_component autoupdate, Api::Autoupdate
    api_component selenium, Api::Selenium
    api_component replacer, Api::Replacer
    api_component reveal, Api::Reveal
    api_component params, Api::Params
    api_component acsrf, Api::Acsrf
    api_component access_control, Api::AccessControl
    api_component automation, Api::Automation
    api_component breakpoints, Api::Breakpoints
    api_component websocket, Api::Websocket
    api_component search, Api::Search
    api_component graphql, Api::Graphql
    api_component soap, Api::Soap
    api_component reports, Api::Reports
    api_component exim, Api::Exim
    api_component client, Api::Client
    api_component client_spider, Api::ClientSpider
    api_component custom_payloads, Api::CustomPayloads
    api_component hud, Api::Hud
    api_component local_proxies, Api::LocalProxies
    api_component oast, Api::Oast
    api_component param_digger, Api::ParamDigger
    api_component pnh, Api::Pnh
    api_component postman, Api::Postman
    api_component retest, Api::Retest
    api_component revisit, Api::Revisit
    api_component rule_config, Api::RuleConfig
    api_component wappalyzer, Api::Wappalyzer
    api_component dev, Api::Dev
    api_component keyboard, Api::Keyboard
    api_component quickstartlaunch, Api::Quickstartlaunch

    # Convenience scanning
    def scan : Scan
      Scan.new(self)
    end

    # Close the underlying HTTP connection and release resources.
    #
    # Takes the same lock as request execution, so closing from one fiber while
    # another is mid-request waits for that request to finish instead of
    # yanking the socket out from under it (which surfaced as a spurious
    # "Network error"/truncated response). A later request transparently opens
    # a fresh connection, and closing twice is a no-op.
    def close
      @request_mutex.synchronize do
        @http.try(&.close)
        @http = nil
      end
    end

    # Low-level request methods
    def request(path : String, params : Hash(String, String) = {} of String => String) : JSON::Any
      response = perform_request(path, params)
      begin
        JSON.parse(response.body)
      rescue ex : JSON::ParseException
        raise Zap::Error.new("Invalid JSON response from #{path}: #{ex.message}")
      end
    end

    def request_other(path : String, params : Hash(String, String) = {} of String => String) : String
      response = perform_request(path, params)
      response.body
    end

    private def perform_request(path : String, params : Hash(String, String)) : HTTP::Client::Response
      # Copy before injecting the key: `params` belongs to the caller. Writing
      # `apikey` into it would (a) plant the secret in a hash the caller may
      # log or inspect, and (b) make a hash that is reused across calls keep a
      # stale key after `api_key=` is reassigned — including re-sending the old
      # key when it has since been cleared.
      query_params = params.dup
      query_params["apikey"] = @api_key unless @api_key.empty?

      query = URI::Params.encode(query_params)

      # Serialize use of the shared HTTP::Client. Crystal's HTTP::Client cannot
      # be used from multiple fibers concurrently, and the same memoized
      # instance backs every API component, so concurrent calls would otherwise
      # interleave requests/responses on one connection. The mutex also guards
      # the lazy construction of `@http`, preventing a race that builds two
      # clients. For the common single-fiber case this is an uncontended lock.
      response = @request_mutex.synchronize do
        begin
          # `http_client` also resolves `@base_path`, so it has to run first.
          client = http_client
          request_path = "#{@base_path}#{path}"
          client.get(query.empty? ? request_path : "#{request_path}?#{query}")
        rescue ex : IO::Error
          # IO::Error is the common ancestor of the socket / TCP, timeout
          # (IO::TimeoutError) and OpenSSL transport failures raised by
          # HTTP::Client. Surface them as the library's error type instead of
          # leaking a raw IO/Socket/OpenSSL exception to callers.
          raise Zap::Error.new("Network error: #{ex.message}")
        end
      end

      unless response.success?
        # The body may echo the request parameters — including any secret
        # the caller just sent (proxy passwords, client-cert PKCS#12
        # passphrases, etc). Stash it on the exception (truncated) so a
        # caller that explicitly inspects `#body` can still debug, but
        # keep it out of the exception message which is what loggers
        # typically print.
        body = response.body
        truncated_body = body.size > 500 ? "#{body[0, 500]}... (truncated)" : body
        raise Zap::HttpError.new(response.status_code, path, truncated_body)
      end

      response
    end

    private def http_client : HTTP::Client
      @http ||= begin
        # A malformed `base_url` makes URI.parse raise URI::Error, or makes
        # HTTP::Client.new raise ArgumentError ("Missing scheme") when the URI
        # lacks a usable scheme/host. Convert both into the library's error
        # type so callers see a clear, typed failure instead of a bare
        # ArgumentError/URI::Error.
        begin
          uri = URI.parse(@base_url)
          client = HTTP::Client.new(uri)
        rescue ex : URI::Error | ArgumentError
          raise Zap::Error.new("Invalid base_url: #{ex.message}")
        end
        # `HTTP::Client.new(uri)` keeps only scheme/host/port — the URI's path
        # is discarded. A `base_url` that mounts ZAP under a prefix (say
        # `https://ci.example/zap`, a common reverse-proxy setup) would
        # therefore send every request to `/JSON/...` at the server root and
        # get an unexplained 404. Remember the prefix and re-apply it to each
        # request path. Endpoint paths always start with "/", so a trailing
        # slash on the prefix is dropped to avoid an empty "//" segment.
        @base_path = uri.path.chomp("/")
        client.connect_timeout = @connect_timeout
        client.read_timeout = @read_timeout
        client
      end
    end
  end
end
