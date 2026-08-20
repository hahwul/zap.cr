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

      # ZAP has no `setOption*` / `option*` variants for the passive scanner —
      # the actions and views are `setMaxAlertsPerRule` / `maxAlertsPerRule`
      # and `setScanOnlyInScope` / `scanOnlyInScope`. These four keep the older
      # method names (with the more convenient argument types) and delegate, so
      # they hit an endpoint that exists instead of failing with `bad_action` /
      # `bad_view`.
      def set_option_max_alerts_per_rule(max : Int32) : JSON::Any
        set_max_alerts_per_rule(max.to_s)
      end

      def set_option_scan_only_in_scope(enabled : Bool) : JSON::Any
        set_scan_only_in_scope(enabled.to_s)
      end

      # Views
      def scanners : JSON::Any
        @client.request("/JSON/pscan/view/scanners/")
      end

      def option_max_alerts_per_rule : JSON::Any
        max_alerts_per_rule
      end

      def option_scan_only_in_scope : JSON::Any
        scan_only_in_scope
      end

      def records_to_scan : JSON::Any
        @client.request("/JSON/pscan/view/recordsToScan/")
      end

      def clear_queue : JSON::Any
        @client.request("/JSON/pscan/action/clearQueue/")
      end

      def disable_all_tags : JSON::Any
        @client.request("/JSON/pscan/action/disableAllTags/")
      end

      def enable_all_tags : JSON::Any
        @client.request("/JSON/pscan/action/enableAllTags/")
      end

      def set_enabled(enabled : String) : JSON::Any
        params = {} of String => String
        params["enabled"] = enabled
        @client.request("/JSON/pscan/action/setEnabled/", params)
      end

      def set_max_alerts_per_rule(max_alerts : String) : JSON::Any
        params = {} of String => String
        params["maxAlerts"] = max_alerts
        @client.request("/JSON/pscan/action/setMaxAlertsPerRule/", params)
      end

      def set_scan_only_in_scope(only_in_scope : String) : JSON::Any
        params = {} of String => String
        params["onlyInScope"] = only_in_scope
        @client.request("/JSON/pscan/action/setScanOnlyInScope/", params)
      end

      def set_scanner_alert_threshold(id : String, alert_threshold : String) : JSON::Any
        params = {} of String => String
        params["id"] = id
        params["alertThreshold"] = alert_threshold
        @client.request("/JSON/pscan/action/setScannerAlertThreshold/", params)
      end

      def current_rule : JSON::Any
        @client.request("/JSON/pscan/view/currentRule/")
      end

      def current_tasks : JSON::Any
        @client.request("/JSON/pscan/view/currentTasks/")
      end

      def max_alerts_per_rule : JSON::Any
        @client.request("/JSON/pscan/view/maxAlertsPerRule/")
      end

      def scan_only_in_scope : JSON::Any
        @client.request("/JSON/pscan/view/scanOnlyInScope/")
      end
    end
  end
end
