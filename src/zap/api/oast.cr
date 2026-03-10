module Zap
  module Api
    class Oast
      def initialize(@client : Zap::Client)
      end

      def set_active_scan_service : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/action/setActiveScanService/", params)
      end

      def set_boast_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/action/setBoastOptions/", params)
      end

      def set_callback_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/action/setCallbackOptions/", params)
      end

      def set_days_to_keep_records : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/action/setDaysToKeepRecords/", params)
      end

      def set_interactsh_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/action/setInteractshOptions/", params)
      end

      def get_active_scan_service : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getActiveScanService/", params)
      end

      def get_boast_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getBoastOptions/", params)
      end

      def get_callback_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getCallbackOptions/", params)
      end

      def get_days_to_keep_records : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getDaysToKeepRecords/", params)
      end

      def get_interactsh_options : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getInteractshOptions/", params)
      end

      def get_services : JSON::Any
        params = {} of String => String
        @client.request("/JSON/oast/view/getServices/", params)
      end
    end
  end
end
