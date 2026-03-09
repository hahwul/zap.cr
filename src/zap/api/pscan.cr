module Zap
  module Api
    class Pscan
      def initialize(@client : Zap::Client)
      end

      # Actions
      def enable_all_scanners : JSON::Any
        @client.request("/JSON/pscan/action/enableAllScanners/")
      end

      def disable_all_scanners : JSON::Any
        @client.request("/JSON/pscan/action/disableAllScanners/")
      end

      def enable_scanners(ids : String) : JSON::Any
        @client.request("/JSON/pscan/action/enableScanners/", {"ids" => ids})
      end

      def disable_scanners(ids : String) : JSON::Any
        @client.request("/JSON/pscan/action/disableScanners/", {"ids" => ids})
      end

      def set_option_max_alerts_per_rule(max : Int32) : JSON::Any
        @client.request("/JSON/pscan/action/setOptionMaxAlertsPerRule/", {"Integer" => max.to_s})
      end

      def set_option_scan_only_in_scope(enabled : Bool) : JSON::Any
        @client.request("/JSON/pscan/action/setOptionScanOnlyInScope/", {"Boolean" => enabled.to_s})
      end

      # Views
      def scanners : JSON::Any
        @client.request("/JSON/pscan/view/scanners/")
      end

      def option_max_alerts_per_rule : JSON::Any
        @client.request("/JSON/pscan/view/optionMaxAlertsPerRule/")
      end

      def option_scan_only_in_scope : JSON::Any
        @client.request("/JSON/pscan/view/optionScanOnlyInScope/")
      end

      def records_to_scan : JSON::Any
        @client.request("/JSON/pscan/view/recordsToScan/")
      end
    end
  end
end
