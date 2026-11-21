module Zap
  module Api
    class Soap
      def initialize(@client : Zap::Client)
      end

      def import_file(file : String, *, max_messages : Int32? = nil) : JSON::Any
        params = {"file" => file}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/soap/action/importFile/", params)
      end

      def import_url(url : String, *, max_messages : Int32? = nil) : JSON::Any
        params = {"url" => url}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/soap/action/importUrl/", params)
      end
    end
  end
end
