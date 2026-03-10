module Zap
  module Api
    class Postman
      def initialize(@client : Zap::Client)
      end

      def import_file : JSON::Any
        params = {} of String => String
        @client.request("/JSON/postman/action/importFile/", params)
      end

      def import_url : JSON::Any
        params = {} of String => String
        @client.request("/JSON/postman/action/importUrl/", params)
      end
    end
  end
end
