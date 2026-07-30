module Zap
  module Api
    class Alert
      def initialize(@client : Zap::Client)
      end

      # Views
      def get(id : Int32) : JSON::Any
        @client.request("/JSON/alert/view/alert/", {"id" => id.to_s})
      end

      # `risk_id` accepts either a raw ZAP `riskId` `Int32` (the historical API,
      # `-1` meaning "no filter") or a `Zap::Risk` enum value, which is mapped to
      # its integer id. Passing the enum reads more clearly at call sites without
      # breaking the existing `Int32` API.
      # `false_positive` filters on whether alerts have been marked as false
      # positives; leaving it `nil` returns both.
      def alerts(base_url : String = "", start : Int32 = -1, count : Int32 = -1, risk_id : Int32 | Zap::Risk = -1, context_name : String = "", false_positive : Bool? = nil) : JSON::Any
        rid = Zap.risk_id(risk_id)
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        params["riskId"] = rid.to_s if rid >= 0
        params["contextName"] = context_name unless context_name.empty?
        params["falsePositive"] = false_positive.to_s unless false_positive.nil?
        @client.request("/JSON/alert/view/alerts/", params)
      end

      def alerts_summary(base_url : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        @client.request("/JSON/alert/view/alertsSummary/", params)
      end

      # `risk_id` accepts a raw `Int32` (`-1` = no filter) or a `Zap::Risk` enum.
      def number_of_alerts(base_url : String = "", risk_id : Int32 | Zap::Risk = -1) : JSON::Any
        rid = Zap.risk_id(risk_id)
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = rid.to_s if rid >= 0
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

      # `risk_id` accepts a raw `Int32` (`-1` = no filter) or a `Zap::Risk` enum.
      def delete_alerts(context_name : String = "", base_url : String = "", risk_id : Int32 | Zap::Risk = -1) : JSON::Any
        rid = Zap.risk_id(risk_id)
        params = {} of String => String
        params["contextName"] = context_name unless context_name.empty?
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = rid.to_s if rid >= 0
        @client.request("/JSON/alert/action/deleteAlerts/", params)
      end

      # `risk_id` / `confidence_id` accept raw `Int32` IDs or the matching
      # `Zap::Risk` / `Zap::Confidence` enums.
      def update_alert(id : Int32, name : String, risk_id : Int32 | Zap::Risk, confidence_id : Int32 | Zap::Confidence, description : String, param : String = "", attack : String = "", other_info : String = "", solution : String = "", references : String = "", evidence : String = "", cwe_id : Int32 = -1, wasc_id : Int32 = -1) : JSON::Any
        params = {"id" => id.to_s, "name" => name, "riskId" => Zap.risk_id(risk_id).to_s, "confidenceId" => Zap.confidence_id(confidence_id).to_s, "description" => description}
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

      # `confidence_id` accepts a raw `Int32` or a `Zap::Confidence` enum.
      def update_alerts_confidence(ids : String, confidence_id : Int32 | Zap::Confidence) : JSON::Any
        @client.request("/JSON/alert/action/updateAlertsConfidence/", {"ids" => ids, "confidenceId" => Zap.confidence_id(confidence_id).to_s})
      end

      # `risk_id` accepts a raw `Int32` or a `Zap::Risk` enum.
      def update_alerts_risk(ids : String, risk_id : Int32 | Zap::Risk) : JSON::Any
        @client.request("/JSON/alert/action/updateAlertsRisk/", {"ids" => ids, "riskId" => Zap.risk_id(risk_id).to_s})
      end

      # `risk_id` / `confidence_id` accept raw `Int32` IDs or the matching
      # `Zap::Risk` / `Zap::Confidence` enums.
      def add_alert(message_id : Int32, name : String, risk_id : Int32 | Zap::Risk, confidence_id : Int32 | Zap::Confidence, description : String, param : String = "", attack : String = "", other_info : String = "", solution : String = "", references : String = "", evidence : String = "", cwe_id : Int32 = -1, wasc_id : Int32 = -1) : JSON::Any
        params = {"messageId" => message_id.to_s, "name" => name, "riskId" => Zap.risk_id(risk_id).to_s, "confidenceId" => Zap.confidence_id(confidence_id).to_s, "description" => description}
        params["param"] = param unless param.empty?
        params["attack"] = attack unless attack.empty?
        params["otherInfo"] = other_info unless other_info.empty?
        params["solution"] = solution unless solution.empty?
        params["references"] = references unless references.empty?
        params["evidence"] = evidence unless evidence.empty?
        params["cweId"] = cwe_id.to_s if cwe_id >= 0
        params["wascId"] = wasc_id.to_s if wasc_id >= 0
        @client.request("/JSON/alert/action/addAlert/", params)
      end
    end
  end
end
