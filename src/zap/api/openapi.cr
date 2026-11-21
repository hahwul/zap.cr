module Zap
  module Api
    class OpenApi
      def initialize(@client : Zap::Client)
      end

      # `user_id` imports the definition as a configured user of `context_id`,
      # so endpoints behind authentication are reachable.
      def import_file(file : String, target : String = "", context_id : Int32 = -1, user_id : Int32 = -1, *, max_messages : Int32? = nil) : JSON::Any
        params = {"file" => file}
        params["target"] = target unless target.empty?
        params["contextId"] = context_id.to_s if context_id >= 0
        params["userId"] = user_id.to_s if user_id >= 0
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/openapi/action/importFile/", params)
      end

      def import_url(url : String, host_override : String = "", context_id : Int32 = -1, user_id : Int32 = -1, *, max_messages : Int32? = nil) : JSON::Any
        params = {"url" => url}
        params["hostOverride"] = host_override unless host_override.empty?
        params["contextId"] = context_id.to_s if context_id >= 0
        params["userId"] = user_id.to_s if user_id >= 0
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/openapi/action/importUrl/", params)
      end
    end
  end
end
