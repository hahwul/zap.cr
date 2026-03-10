module Zap
  module Api
    class ClientSpider
      def initialize(@client : Zap::Client)
      end

      def scan : JSON::Any
        params = {} of String => String
        @client.request("/JSON/clientSpider/action/scan/", params)
      end

      def stop : JSON::Any
        params = {} of String => String
        @client.request("/JSON/clientSpider/action/stop/", params)
      end

      def status : JSON::Any
        params = {} of String => String
        @client.request("/JSON/clientSpider/view/status/", params)
      end
    end
  end
end
