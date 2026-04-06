module Zap
  module Api
    class Pnh
      def initialize(@client : Zap::Client)
      end

      def monitor : JSON::Any
        @client.request("/JSON/pnh/action/monitor/")
      end

      def oracle : JSON::Any
        @client.request("/JSON/pnh/action/oracle/")
      end

      def start_monitoring : JSON::Any
        @client.request("/JSON/pnh/action/startMonitoring/")
      end

      def stop_monitoring : JSON::Any
        @client.request("/JSON/pnh/action/stopMonitoring/")
      end

      def fx_pnh_xpi : String
        @client.request_other("/OTHER/pnh/other/fx_pnh.xpi/")
      end

      def manifest : String
        @client.request_other("/OTHER/pnh/other/manifest/")
      end

      def pnh : String
        @client.request_other("/OTHER/pnh/other/pnh/")
      end

      def service : String
        @client.request_other("/OTHER/pnh/other/service/")
      end
    end
  end
end
