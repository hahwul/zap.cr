module Zap
  module Api
    class Soap
      def initialize(@client : Zap::Client)
      end

      def import_file(file : String) : JSON::Any
        @client.request("/JSON/soap/action/importFile/", {"file" => file})
      end

      def import_url(url : String) : JSON::Any
        @client.request("/JSON/soap/action/importUrl/", {"url" => url})
      end
    end
  end
end
