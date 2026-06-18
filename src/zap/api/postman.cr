module Zap
  module Api
    class Postman
      def initialize(@client : Zap::Client)
      end

      # Imports a Postman collection from a local file. ZAP requires the `file`
      # parameter, so it is mandatory here.
      def import_file(file : String) : JSON::Any
        @client.request("/JSON/postman/action/importFile/", {"file" => file})
      end

      # Imports a Postman collection from a URL. ZAP requires the `url` parameter,
      # so it is mandatory here.
      def import_url(url : String) : JSON::Any
        @client.request("/JSON/postman/action/importUrl/", {"url" => url})
      end
    end
  end
end
