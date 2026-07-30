module Zap
  module Api
    class AlertFilter
      def initialize(@client : Zap::Client)
      end

      def alert_filter_list(context_id : Int32) : JSON::Any
        @client.request("/JSON/alertFilter/view/alertFilterList/", {"contextId" => context_id.to_s})
      end

      def global_alert_filter_list : JSON::Any
        @client.request("/JSON/alertFilter/view/globalAlertFilterList/")
      end

      # Adds/removes an alert filter, which rewrites the risk of alerts raised
      # by `rule_id` to `new_level`.
      #
      # A filter matches on any combination of URL, parameter, attack and
      # evidence, each of which can be a literal or a regex, plus an optional
      # comma-separated list of HTTP `methods`. Criteria left empty are not
      # sent, so they do not narrow the filter. `new_level` accepts a raw ZAP
      # level `Int32` or a `Zap::Risk` enum.
      def add_alert_filter(
        context_id : Int32,
        rule_id : Int32,
        new_level : Int32 | Zap::Risk,
        url : String = "",
        url_is_regex : Bool = false,
        parameter : String = "",
        enabled : Bool = true,
        parameter_is_regex : Bool = false,
        attack : String = "",
        attack_is_regex : Bool = false,
        evidence : String = "",
        evidence_is_regex : Bool = false,
        methods : String = "",
      ) : JSON::Any
        params = filter_params(rule_id, new_level, url, url_is_regex, parameter, enabled,
          parameter_is_regex, attack, attack_is_regex, evidence, evidence_is_regex, methods)
        params["contextId"] = context_id.to_s
        @client.request("/JSON/alertFilter/action/addAlertFilter/", params)
      end

      def remove_alert_filter(
        context_id : Int32,
        rule_id : Int32,
        new_level : Int32 | Zap::Risk,
        url : String = "",
        url_is_regex : Bool = false,
        parameter : String = "",
        enabled : Bool = true,
        parameter_is_regex : Bool = false,
        attack : String = "",
        attack_is_regex : Bool = false,
        evidence : String = "",
        evidence_is_regex : Bool = false,
        methods : String = "",
      ) : JSON::Any
        params = filter_params(rule_id, new_level, url, url_is_regex, parameter, enabled,
          parameter_is_regex, attack, attack_is_regex, evidence, evidence_is_regex, methods)
        params["contextId"] = context_id.to_s
        @client.request("/JSON/alertFilter/action/removeAlertFilter/", params)
      end

      def add_global_alert_filter(
        rule_id : Int32,
        new_level : Int32 | Zap::Risk,
        url : String = "",
        url_is_regex : Bool = false,
        parameter : String = "",
        enabled : Bool = true,
        parameter_is_regex : Bool = false,
        attack : String = "",
        attack_is_regex : Bool = false,
        evidence : String = "",
        evidence_is_regex : Bool = false,
        methods : String = "",
      ) : JSON::Any
        @client.request("/JSON/alertFilter/action/addGlobalAlertFilter/",
          filter_params(rule_id, new_level, url, url_is_regex, parameter, enabled,
            parameter_is_regex, attack, attack_is_regex, evidence, evidence_is_regex, methods))
      end

      def remove_global_alert_filter(
        rule_id : Int32,
        new_level : Int32 | Zap::Risk,
        url : String = "",
        url_is_regex : Bool = false,
        parameter : String = "",
        enabled : Bool = true,
        parameter_is_regex : Bool = false,
        attack : String = "",
        attack_is_regex : Bool = false,
        evidence : String = "",
        evidence_is_regex : Bool = false,
        methods : String = "",
      ) : JSON::Any
        @client.request("/JSON/alertFilter/action/removeGlobalAlertFilter/",
          filter_params(rule_id, new_level, url, url_is_regex, parameter, enabled,
            parameter_is_regex, attack, attack_is_regex, evidence, evidence_is_regex, methods))
      end

      def apply_all : JSON::Any
        @client.request("/JSON/alertFilter/action/applyAll/")
      end

      # Applies / tests every currently enabled context alert filter. ZAP has
      # no per-context variant of these actions — they operate on all
      # contexts at once.
      def apply_context : JSON::Any
        @client.request("/JSON/alertFilter/action/applyContext/")
      end

      def apply_global : JSON::Any
        @client.request("/JSON/alertFilter/action/applyGlobal/")
      end

      def test_all : JSON::Any
        @client.request("/JSON/alertFilter/action/testAll/")
      end

      def test_context : JSON::Any
        @client.request("/JSON/alertFilter/action/testContext/")
      end

      def test_global : JSON::Any
        @client.request("/JSON/alertFilter/action/testGlobal/")
      end

      private def filter_params(
        rule_id : Int32,
        new_level : Int32 | Zap::Risk,
        url : String,
        url_is_regex : Bool,
        parameter : String,
        enabled : Bool,
        parameter_is_regex : Bool,
        attack : String,
        attack_is_regex : Bool,
        evidence : String,
        evidence_is_regex : Bool,
        methods : String,
      ) : Hash(String, String)
        params = {
          "ruleId"   => rule_id.to_s,
          "newLevel" => Zap.risk_id(new_level).to_s,
          "enabled"  => enabled.to_s,
        }
        unless url.empty?
          params["url"] = url
          params["urlIsRegex"] = url_is_regex.to_s
        end
        unless parameter.empty?
          params["parameter"] = parameter
          params["parameterIsRegex"] = parameter_is_regex.to_s
        end
        unless attack.empty?
          params["attack"] = attack
          params["attackIsRegex"] = attack_is_regex.to_s
        end
        unless evidence.empty?
          params["evidence"] = evidence
          params["evidenceIsRegex"] = evidence_is_regex.to_s
        end
        params["methods"] = methods unless methods.empty?
        params
      end
    end
  end
end
