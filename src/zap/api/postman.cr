module Zap
  module Api
    class Postman
      def initialize(@client : Zap::Client)
      end

      def import_file : JSON::Any
        @client.request("/JSON/postman/action/importFile/")
      end

      def import_url : JSON::Any
        @client.request("/JSON/postman/action/importUrl/")
      end
    end
  end
end
