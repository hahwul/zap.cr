module Zap
  module Api
    class SessionManagement
      def initialize(@client : Zap::Client)
      end

      def get_method(context_id : Int32) : JSON::Any
        @client.request("/JSON/sessionManagement/view/getSessionManagementMethod/", {"contextId" => context_id.to_s})
      end

      def get_method_config_params(method_name : String) : JSON::Any
        @client.request("/JSON/sessionManagement/view/getSessionManagementMethodConfigParams/", {"methodName" => method_name})
      end

      def supported_methods : JSON::Any
        @client.request("/JSON/sessionManagement/view/getSupportedSessionManagementMethods/")
      end

      def set_method(context_id : Int32, method_name : String, method_config_params : String = "") : JSON::Any
        params = {"contextId" => context_id.to_s, "methodName" => method_name}
        params["methodConfigParams"] = method_config_params unless method_config_params.empty?
        @client.request("/JSON/sessionManagement/action/setSessionManagementMethod/", params)
      end

      def get_session_management_method(context_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        @client.request("/JSON/sessionManagement/view/getSessionManagementMethod/", params)
      end

      def get_session_management_method_config_params(method_name : String) : JSON::Any
        params = {} of String => String
        params["methodName"] = method_name
        @client.request("/JSON/sessionManagement/view/getSessionManagementMethodConfigParams/", params)
      end

      def get_supported_session_management_methods : JSON::Any
        params = {} of String => String
        @client.request("/JSON/sessionManagement/view/getSupportedSessionManagementMethods/", params)
      end

      def set_session_management_method(context_id : String, method_name : String, method_config_params : String? = nil) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["methodName"] = method_name
        params["methodConfigParams"] = method_config_params unless method_config_params.nil?
        @client.request("/JSON/sessionManagement/action/setSessionManagementMethod/", params)
      end
    end
  end
end
