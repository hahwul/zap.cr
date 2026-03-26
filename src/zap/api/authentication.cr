module Zap
  module Api
    class Authentication
      def initialize(@client : Zap::Client)
      end

      # Views
      def get_method(context_id : Int32) : JSON::Any
        @client.request("/JSON/authentication/view/getAuthenticationMethod/", {"contextId" => context_id.to_s})
      end

      def get_method_config_params(method_name : String) : JSON::Any
        @client.request("/JSON/authentication/view/getAuthenticationMethodConfigParams/", {"authMethodName" => method_name})
      end

      def get_logged_in_indicator(context_id : Int32) : JSON::Any
        @client.request("/JSON/authentication/view/getLoggedInIndicator/", {"contextId" => context_id.to_s})
      end

      def get_logged_out_indicator(context_id : Int32) : JSON::Any
        @client.request("/JSON/authentication/view/getLoggedOutIndicator/", {"contextId" => context_id.to_s})
      end

      def supported_methods : JSON::Any
        @client.request("/JSON/authentication/view/getSupportedAuthenticationMethods/")
      end

      # Actions
      def set_method(context_id : Int32, method_name : String, method_config_params : String = "") : JSON::Any
        params = {"contextId" => context_id.to_s, "authMethodName" => method_name}
        params["authMethodConfigParams"] = method_config_params unless method_config_params.empty?
        @client.request("/JSON/authentication/action/setAuthenticationMethod/", params)
      end

      def set_logged_in_indicator(context_id : Int32, indicator : String) : JSON::Any
        @client.request("/JSON/authentication/action/setLoggedInIndicator/", {"contextId" => context_id.to_s, "loggedInIndicatorRegex" => indicator})
      end

      def set_logged_out_indicator(context_id : Int32, indicator : String) : JSON::Any
        @client.request("/JSON/authentication/action/setLoggedOutIndicator/", {"contextId" => context_id.to_s, "loggedOutIndicatorRegex" => indicator})
      end

    end
  end
end
