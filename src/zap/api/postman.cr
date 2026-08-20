module Zap
  module Api
    class Postman
      def initialize(@client : Zap::Client)
      end

      # Imports a Postman collection from a local file. ZAP requires the `file`
      # parameter, so it is mandatory here. `endpoint_url` overrides the URL
      # the collection's requests are sent to.
      def import_file(file : String, endpoint_url : String = "") : JSON::Any
        params = {"file" => file}
        params["endpointUrl"] = endpoint_url unless endpoint_url.empty?
        @client.request("/JSON/postman/action/importFile/", params)
      end

      # Imports a Postman collection from a URL. ZAP requires the `url` parameter,
      # so it is mandatory here.
      def import_url(url : String, endpoint_url : String = "") : JSON::Any
        params = {"url" => url}
        params["endpointUrl"] = endpoint_url unless endpoint_url.empty?
        @client.request("/JSON/postman/action/importUrl/", params)
      end
    end
  end
end
