module Zap
  module Api
    class AccessControl
      def initialize(@client : Zap::Client)
      end

      def scan_status(context_id : Int32) : JSON::Any
        @client.request("/JSON/accessControl/view/getScanStatus/", {"contextId" => context_id.to_s})
      end

      def scan_progress(context_id : Int32) : JSON::Any
        @client.request("/JSON/accessControl/view/getScanProgress/", {"contextId" => context_id.to_s})
      end

      # Starts an access-control scan. ZAP requires the user to scan as, in
      # addition to the context. Optionally also scan as an unauthenticated
      # user, and control whether alerts are raised (and at what risk level).
      def scan(context_id : Int32, user_id : Int32, scan_as_unauth_user : Bool? = nil, raise_alert : Bool? = nil, alert_risk_level : String = "") : JSON::Any
        params = {"contextId" => context_id.to_s, "userId" => user_id.to_s}
        params["scanAsUnAuthUser"] = scan_as_unauth_user.to_s unless scan_as_unauth_user.nil?
        params["raiseAlert"] = raise_alert.to_s unless raise_alert.nil?
        params["alertRiskLevel"] = alert_risk_level unless alert_risk_level.empty?
        @client.request("/JSON/accessControl/action/scan/", params)
      end

      def write_html_report(context_id : Int32, file_name : String) : JSON::Any
        @client.request("/JSON/accessControl/action/writeHTMLreport/", {"contextId" => context_id.to_s, "fileName" => file_name})
      end
    end
  end
end
