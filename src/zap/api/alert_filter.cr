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

      def add_alert_filter(context_id : Int32, rule_id : Int32, new_level : Int32, url : String = "", url_is_regex : Bool = false, parameter : String = "", enabled : Bool = true) : JSON::Any
        params = {"contextId" => context_id.to_s, "ruleId" => rule_id.to_s, "newLevel" => new_level.to_s, "enabled" => enabled.to_s}
        params["url"] = url unless url.empty?
        params["urlIsRegex"] = url_is_regex.to_s
        params["parameter"] = parameter unless parameter.empty?
        @client.request("/JSON/alertFilter/action/addAlertFilter/", params)
      end

      def remove_alert_filter(context_id : Int32, rule_id : Int32, new_level : Int32, url : String = "", url_is_regex : Bool = false, parameter : String = "", enabled : Bool = true) : JSON::Any
        params = {"contextId" => context_id.to_s, "ruleId" => rule_id.to_s, "newLevel" => new_level.to_s, "enabled" => enabled.to_s}
        params["url"] = url unless url.empty?
        params["urlIsRegex"] = url_is_regex.to_s
        params["parameter"] = parameter unless parameter.empty?
        @client.request("/JSON/alertFilter/action/removeAlertFilter/", params)
      end

      def add_global_alert_filter(rule_id : Int32, new_level : Int32, url : String = "", url_is_regex : Bool = false, parameter : String = "", enabled : Bool = true) : JSON::Any
        params = {"ruleId" => rule_id.to_s, "newLevel" => new_level.to_s, "enabled" => enabled.to_s}
        params["url"] = url unless url.empty?
        params["urlIsRegex"] = url_is_regex.to_s
        params["parameter"] = parameter unless parameter.empty?
        @client.request("/JSON/alertFilter/action/addGlobalAlertFilter/", params)
      end

      def remove_global_alert_filter(rule_id : Int32, new_level : Int32, url : String = "", url_is_regex : Bool = false, parameter : String = "", enabled : Bool = true) : JSON::Any
        params = {"ruleId" => rule_id.to_s, "newLevel" => new_level.to_s, "enabled" => enabled.to_s}
        params["url"] = url unless url.empty?
        params["urlIsRegex"] = url_is_regex.to_s
        params["parameter"] = parameter unless parameter.empty?
        @client.request("/JSON/alertFilter/action/removeGlobalAlertFilter/", params)
      end

      def apply_all : JSON::Any
        @client.request("/JSON/alertFilter/action/applyAll/")
      end

      def apply_context(context_id : Int32) : JSON::Any
        @client.request("/JSON/alertFilter/action/applyContext/", {"contextId" => context_id.to_s})
      end

      def apply_global : JSON::Any
        @client.request("/JSON/alertFilter/action/applyGlobal/")
      end

      def test_all : JSON::Any
        @client.request("/JSON/alertFilter/action/testAll/")
      end

      def test_context(context_id : Int32) : JSON::Any
        @client.request("/JSON/alertFilter/action/testContext/", {"contextId" => context_id.to_s})
      end

      def test_global : JSON::Any
        @client.request("/JSON/alertFilter/action/testGlobal/")
      end
    end
  end
end
