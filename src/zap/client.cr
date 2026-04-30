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
    property base_url : String
    property api_key : String
    property connect_timeout : Time::Span
    property read_timeout : Time::Span

    @http : HTTP::Client?

    def initialize(
      @base_url : String = "http://localhost:8080",
      @api_key : String = "",
      @connect_timeout : Time::Span = 30.seconds,
      @read_timeout : Time::Span = 300.seconds,
    )
    end

    # API components (lazily cached)
    macro api_component(name, type)
      @_{{name.id}} : {{type}}?

      def {{name.id}} : {{type}}
        @_{{name.id}} ||= {{type}}.new(self)
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
    def close
      @http.try(&.close)
      @http = nil
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
      params["apikey"] = @api_key unless @api_key.empty?

      query = URI::Params.encode(params)
      full_path = query.empty? ? path : "#{path}?#{query}"

      response = http_client.get(full_path)

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
        uri = URI.parse(@base_url)
        client = HTTP::Client.new(uri)
        client.connect_timeout = @connect_timeout
        client.read_timeout = @read_timeout
        client
      end
    end
  end
end
