module Zap
  module Api
    class OpenApi
      def initialize(@client : Zap::Client)
      end

      def import_file(file : String, target : String = "", context_id : Int32 = -1) : JSON::Any
        params = {"file" => file}
        params["target"] = target unless target.empty?
        params["contextId"] = context_id.to_s if context_id >= 0
        @client.request("/JSON/openapi/action/importFile/", params)
      end

      def import_url(url : String, host_override : String = "", context_id : Int32 = -1) : JSON::Any
        params = {"url" => url}
        params["hostOverride"] = host_override unless host_override.empty?
        params["contextId"] = context_id.to_s if context_id >= 0
        @client.request("/JSON/openapi/action/importUrl/", params)
      end
    end
  end
end
