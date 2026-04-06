module Zap
  module Api
    class Oast
      def initialize(@client : Zap::Client)
      end

      def set_active_scan_service : JSON::Any
        @client.request("/JSON/oast/action/setActiveScanService/")
      end

      def set_boast_options : JSON::Any
        @client.request("/JSON/oast/action/setBoastOptions/")
      end

      def set_callback_options : JSON::Any
        @client.request("/JSON/oast/action/setCallbackOptions/")
      end

      def set_days_to_keep_records : JSON::Any
        @client.request("/JSON/oast/action/setDaysToKeepRecords/")
      end

      def set_interactsh_options : JSON::Any
        @client.request("/JSON/oast/action/setInteractshOptions/")
      end

      def get_active_scan_service : JSON::Any
        @client.request("/JSON/oast/view/getActiveScanService/")
      end

      def get_boast_options : JSON::Any
        @client.request("/JSON/oast/view/getBoastOptions/")
      end

      def get_callback_options : JSON::Any
        @client.request("/JSON/oast/view/getCallbackOptions/")
      end

      def get_days_to_keep_records : JSON::Any
        @client.request("/JSON/oast/view/getDaysToKeepRecords/")
      end

      def get_interactsh_options : JSON::Any
        @client.request("/JSON/oast/view/getInteractshOptions/")
      end

      def get_services : JSON::Any
        @client.request("/JSON/oast/view/getServices/")
      end
    end
  end
end
