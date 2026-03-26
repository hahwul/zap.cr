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

    end
  end
end
