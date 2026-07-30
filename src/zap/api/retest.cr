module Zap
  module Api
    class Retest
      def initialize(@client : Zap::Client)
      end

      # Re-runs the scan rules that raised the given alerts. `alert_ids` is
      # ZAP's comma-separated list of alert ids and is required.
      def retest(alert_ids : String) : JSON::Any
        @client.request("/JSON/retest/action/retest/", {"alertIds" => alert_ids})
      end
    end
  end
end
