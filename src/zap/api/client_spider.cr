module Zap
  module Api
    class ClientSpider
      def initialize(@client : Zap::Client)
      end

      def scan : JSON::Any
        @client.request("/JSON/clientSpider/action/scan/")
      end

      def stop : JSON::Any
        @client.request("/JSON/clientSpider/action/stop/")
      end

      def status : JSON::Any
        @client.request("/JSON/clientSpider/view/status/")
      end
    end
  end
end
