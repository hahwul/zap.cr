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

      def get_authorization_detection_method(context_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        @client.request("/JSON/authorization/view/getAuthorizationDetectionMethod/", params)
      end

      def set_basic_authorization_detection_method(context_id : String, header_regex : String? = nil, body_regex : String? = nil, status_code : String? = nil, logical_operator : String? = nil) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["headerRegex"] = header_regex unless header_regex.nil?
        params["bodyRegex"] = body_regex unless body_regex.nil?
        params["statusCode"] = status_code unless status_code.nil?
        params["logicalOperator"] = logical_operator unless logical_operator.nil?
        @client.request("/JSON/authorization/action/setBasicAuthorizationDetectionMethod/", params)
      end
    end
  end
end
