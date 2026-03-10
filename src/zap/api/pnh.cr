module Zap
  module Api
    class Pnh
      def initialize(@client : Zap::Client)
      end

      def monitor : JSON::Any
        params = {} of String => String
        @client.request("/JSON/pnh/action/monitor/", params)
      end

      def oracle : JSON::Any
        params = {} of String => String
        @client.request("/JSON/pnh/action/oracle/", params)
      end

      def start_monitoring : JSON::Any
        params = {} of String => String
        @client.request("/JSON/pnh/action/startMonitoring/", params)
      end

      def stop_monitoring : JSON::Any
        params = {} of String => String
        @client.request("/JSON/pnh/action/stopMonitoring/", params)
      end

      def fx_pnh_xpi : String
        params = {} of String => String
        @client.request_other("/OTHER/pnh/other/fx_pnh.xpi/", params)
      end

      def manifest : String
        params = {} of String => String
        @client.request_other("/OTHER/pnh/other/manifest/", params)
      end

      def pnh : String
        params = {} of String => String
        @client.request_other("/OTHER/pnh/other/pnh/", params)
      end

      def service : String
        params = {} of String => String
        @client.request_other("/OTHER/pnh/other/service/", params)
      end
    end
  end
end
