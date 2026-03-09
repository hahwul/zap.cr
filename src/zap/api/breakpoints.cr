module Zap
  module Api
    class Breakpoints
      def initialize(@client : Zap::Client)
      end

      def breakpoints : JSON::Any
        @client.request("/JSON/break/view/isBreakAll/")
      end

      def is_break_all : JSON::Any
        @client.request("/JSON/break/view/isBreakAll/")
      end

      def is_break_request : JSON::Any
        @client.request("/JSON/break/view/isBreakRequest/")
      end

      def is_break_response : JSON::Any
        @client.request("/JSON/break/view/isBreakResponse/")
      end

      def http_message : JSON::Any
        @client.request("/JSON/break/view/httpMessage/")
      end

      def brk(break_type : String, state : String, scope : String = "") : JSON::Any
        params = {"type" => break_type, "state" => state}
        params["scope"] = scope unless scope.empty?
        @client.request("/JSON/break/action/break/", params)
      end

      def set_http_message(header : String, body : String = "") : JSON::Any
        params = {"httpHeader" => header}
        params["httpBody"] = body unless body.empty?
        @client.request("/JSON/break/action/setHttpMessage/", params)
      end

      def continue : JSON::Any
        @client.request("/JSON/break/action/continue/")
      end

      def step : JSON::Any
        @client.request("/JSON/break/action/step/")
      end

      def drop : JSON::Any
        @client.request("/JSON/break/action/drop/")
      end

      def add_http_breakpoint(string : String, location : String, match : String, inverse : Bool, ignorecase : Bool) : JSON::Any
        @client.request("/JSON/break/action/addHttpBreakpoint/", {
          "string" => string, "location" => location, "match" => match,
          "inverse" => inverse.to_s, "ignorecase" => ignorecase.to_s,
        })
      end

      def remove_http_breakpoint(string : String, location : String, match : String, inverse : Bool, ignorecase : Bool) : JSON::Any
        @client.request("/JSON/break/action/removeHttpBreakpoint/", {
          "string" => string, "location" => location, "match" => match,
          "inverse" => inverse.to_s, "ignorecase" => ignorecase.to_s,
        })
      end
    end
  end
end
