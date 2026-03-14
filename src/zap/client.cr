module Zap
  class Error < Exception; end

  class HttpError < Error
    getter status_code : Int32

    def initialize(@status_code : Int32, message : String)
      super("HTTP #{@status_code}: #{message}")
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

    # API components
    def core : Api::Core
      Api::Core.new(self)
    end

    def spider : Api::Spider
      Api::Spider.new(self)
    end

    def ajax_spider : Api::AjaxSpider
      Api::AjaxSpider.new(self)
    end

    def ascan : Api::Ascan
      Api::Ascan.new(self)
    end

    def pscan : Api::Pscan
      Api::Pscan.new(self)
    end

    def alert : Api::Alert
      Api::Alert.new(self)
    end

    def alert_filter : Api::AlertFilter
      Api::AlertFilter.new(self)
    end

    def context : Api::Context
      Api::Context.new(self)
    end

    def authentication : Api::Authentication
      Api::Authentication.new(self)
    end

    def authorization : Api::Authorization
      Api::Authorization.new(self)
    end

    def forced_user : Api::ForcedUser
      Api::ForcedUser.new(self)
    end

    def http_sessions : Api::HttpSessions
      Api::HttpSessions.new(self)
    end

    def users : Api::Users
      Api::Users.new(self)
    end

    def script : Api::Script
      Api::Script.new(self)
    end

    def network : Api::Network
      Api::Network.new(self)
    end

    def openapi : Api::OpenApi
      Api::OpenApi.new(self)
    end

    def stats : Api::Stats
      Api::Stats.new(self)
    end

    def session_management : Api::SessionManagement
      Api::SessionManagement.new(self)
    end

    def autoupdate : Api::Autoupdate
      Api::Autoupdate.new(self)
    end

    def selenium : Api::Selenium
      Api::Selenium.new(self)
    end

    def replacer : Api::Replacer
      Api::Replacer.new(self)
    end

    def reveal : Api::Reveal
      Api::Reveal.new(self)
    end

    def params : Api::Params
      Api::Params.new(self)
    end

    def acsrf : Api::Acsrf
      Api::Acsrf.new(self)
    end

    def access_control : Api::AccessControl
      Api::AccessControl.new(self)
    end

    def automation : Api::Automation
      Api::Automation.new(self)
    end

    def breakpoints : Api::Breakpoints
      Api::Breakpoints.new(self)
    end

    def websocket : Api::Websocket
      Api::Websocket.new(self)
    end

    def search : Api::Search
      Api::Search.new(self)
    end

    def graphql : Api::Graphql
      Api::Graphql.new(self)
    end

    def soap : Api::Soap
      Api::Soap.new(self)
    end

    def reports : Api::Reports
      Api::Reports.new(self)
    end

    def exim : Api::Exim
      Api::Exim.new(self)
    end

    def client : Api::Client
      Api::Client.new(self)
    end

    def client_spider : Api::ClientSpider
      Api::ClientSpider.new(self)
    end

    def custom_payloads : Api::CustomPayloads
      Api::CustomPayloads.new(self)
    end

    def hud : Api::Hud
      Api::Hud.new(self)
    end

    def local_proxies : Api::LocalProxies
      Api::LocalProxies.new(self)
    end

    def oast : Api::Oast
      Api::Oast.new(self)
    end

    def param_digger : Api::ParamDigger
      Api::ParamDigger.new(self)
    end

    def pnh : Api::Pnh
      Api::Pnh.new(self)
    end

    def postman : Api::Postman
      Api::Postman.new(self)
    end

    def retest : Api::Retest
      Api::Retest.new(self)
    end

    def revisit : Api::Revisit
      Api::Revisit.new(self)
    end

    def rule_config : Api::RuleConfig
      Api::RuleConfig.new(self)
    end

    def wappalyzer : Api::Wappalyzer
      Api::Wappalyzer.new(self)
    end

    def dev : Api::Dev
      Api::Dev.new(self)
    end

    def keyboard : Api::Keyboard
      Api::Keyboard.new(self)
    end

    def quickstartlaunch : Api::Quickstartlaunch
      Api::Quickstartlaunch.new(self)
    end

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
        raise Zap::HttpError.new(response.status_code, response.body)
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
