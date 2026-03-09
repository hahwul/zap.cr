module Zap
  class Client
    property base_url : String
    property api_key : String

    def initialize(@base_url : String = "http://localhost:8080", @api_key : String = "")
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

    # Convenience scanning
    def scan : Scan
      Scan.new(self)
    end

    # Low-level request methods
    def request(path : String, params : Hash(String, String) = {} of String => String) : JSON::Any
      params["apikey"] = @api_key unless @api_key.empty?

      uri = URI.parse(@base_url)
      query = URI::Params.encode(params)
      full_path = query.empty? ? path : "#{path}?#{query}"

      http = HTTP::Client.new(uri)
      http.connect_timeout = 30.seconds
      http.read_timeout = 300.seconds

      response = http.get(full_path)
      JSON.parse(response.body)
    end

    def request_other(path : String, params : Hash(String, String) = {} of String => String) : String
      params["apikey"] = @api_key unless @api_key.empty?

      uri = URI.parse(@base_url)
      query = URI::Params.encode(params)
      full_path = query.empty? ? path : "#{path}?#{query}"

      http = HTTP::Client.new(uri)
      http.connect_timeout = 30.seconds
      http.read_timeout = 300.seconds

      response = http.get(full_path)
      response.body
    end
  end
end
