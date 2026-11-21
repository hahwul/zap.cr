module Zap
  module Api
    class Postman
      def initialize(@client : Zap::Client)
      end

      # Imports a Postman collection from a file on the ZAP daemon.
      def import_file(file : String, endpoint_url : String = "", *, max_messages : Int32? = nil) : JSON::Any
        raise Zap::Error.new("Configure endpoint URLs in the Postman collection") unless endpoint_url.empty?
        params = {"file" => file}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/postman/action/importFile/", params)
      end

      # Imports a Postman collection from a URL. ZAP requires the `url` parameter,
      # so it is mandatory here.
      def import_url(url : String, endpoint_url : String = "", *, max_messages : Int32? = nil) : JSON::Any
        raise Zap::Error.new("Configure endpoint URLs in the Postman collection") unless endpoint_url.empty?
        params = {"url" => url}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/postman/action/importUrl/", params)
      end
    end
  end
end
