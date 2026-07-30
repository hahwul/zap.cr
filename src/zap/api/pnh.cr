module Zap
  module Api
    class Pnh
      def initialize(@client : Zap::Client)
      end

      def monitor(id : String, message : String) : JSON::Any
        @client.request("/JSON/pnh/action/monitor/", {"id" => id, "message" => message})
      end

      def oracle(id : String) : JSON::Any
        @client.request("/JSON/pnh/action/oracle/", {"id" => id})
      end

      def start_monitoring(url : String) : JSON::Any
        @client.request("/JSON/pnh/action/startMonitoring/", {"url" => url})
      end

      def stop_monitoring(id : String) : JSON::Any
        @client.request("/JSON/pnh/action/stopMonitoring/", {"id" => id})
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
