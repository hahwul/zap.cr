module Zap
  module Api
    class Alert
      def initialize(@client : Zap::Client)
      end

      # Views
      def get(id : Int32) : JSON::Any
        @client.request("/JSON/alert/view/alert/", {"id" => id.to_s})
      end

      def alerts(base_url : String = "", start : Int32 = -1, count : Int32 = -1, risk_id : Int32 = -1, context_name : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        params["riskId"] = risk_id.to_s if risk_id >= 0
        params["contextName"] = context_name unless context_name.empty?
        @client.request("/JSON/alert/view/alerts/", params)
      end

      def alerts_summary(base_url : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        @client.request("/JSON/alert/view/alertsSummary/", params)
      end

      def number_of_alerts(base_url : String = "", risk_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = risk_id.to_s if risk_id >= 0
        @client.request("/JSON/alert/view/numberOfAlerts/", params)
      end

      def alerts_by_risk(url : String = "", recurse : Bool = true) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["recurse"] = recurse.to_s
        @client.request("/JSON/alert/view/alertsByRisk/", params)
      end

      def alert_counts_by_risk(url : String = "", recurse : Bool = true) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["recurse"] = recurse.to_s
        @client.request("/JSON/alert/view/alertCountsByRisk/", params)
      end

      # Actions
      def delete_alert(id : Int32) : JSON::Any
        @client.request("/JSON/alert/action/deleteAlert/", {"id" => id.to_s})
      end

      def delete_all_alerts : JSON::Any
        @client.request("/JSON/alert/action/deleteAllAlerts/")
      end

      def delete_alerts(context_name : String = "", base_url : String = "", risk_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["contextName"] = context_name unless context_name.empty?
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = risk_id.to_s if risk_id >= 0
        @client.request("/JSON/alert/action/deleteAlerts/", params)
      end

      def update_alert(id : Int32, name : String, risk_id : Int32, confidence_id : Int32, description : String, param : String = "", attack : String = "", other_info : String = "", solution : String = "", references : String = "", evidence : String = "", cwe_id : Int32 = -1, wasc_id : Int32 = -1) : JSON::Any
        params = {"id" => id.to_s, "name" => name, "riskId" => risk_id.to_s, "confidenceId" => confidence_id.to_s, "description" => description}
        params["param"] = param unless param.empty?
        params["attack"] = attack unless attack.empty?
        params["otherInfo"] = other_info unless other_info.empty?
        params["solution"] = solution unless solution.empty?
        params["references"] = references unless references.empty?
        params["evidence"] = evidence unless evidence.empty?
        params["cweId"] = cwe_id.to_s if cwe_id >= 0
        params["wascId"] = wasc_id.to_s if wasc_id >= 0
        @client.request("/JSON/alert/action/updateAlert/", params)
      end

      def update_alerts_confidence(ids : String, confidence_id : Int32) : JSON::Any
        @client.request("/JSON/alert/action/updateAlertsConfidence/", {"ids" => ids, "confidenceId" => confidence_id.to_s})
      end

      def update_alerts_risk(ids : String, risk_id : Int32) : JSON::Any
        @client.request("/JSON/alert/action/updateAlertsRisk/", {"ids" => ids, "riskId" => risk_id.to_s})
      end
    end
  end
end
