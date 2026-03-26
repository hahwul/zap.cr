module Zap
  module Api
    class Authorization
      def initialize(@client : Zap::Client)
      end

      def get_method(context_id : Int32) : JSON::Any
        @client.request("/JSON/authorization/view/getAuthorizationDetectionMethod/", {"contextId" => context_id.to_s})
      end

      def set_basic_method(context_id : Int32, header_regex : String = "", body_regex : String = "", status_code : Int32 = -1, logical_operator : String = "AND") : JSON::Any
        params = {"contextId" => context_id.to_s, "logicalOperator" => logical_operator}
        params["headerRegex"] = header_regex unless header_regex.empty?
        params["bodyRegex"] = body_regex unless body_regex.empty?
        params["statusCode"] = status_code.to_s if status_code >= 0
        @client.request("/JSON/authorization/action/setBasicAuthorizationDetectionMethod/", params)
      end

    end
  end
end
