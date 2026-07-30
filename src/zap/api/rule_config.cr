module Zap
  module Api
    # Scan-rule configuration values, keyed by ZAP's `rules.*` config keys
    # (e.g. `rules.common.sleep`). Use `#all_rule_configs` to discover them.
    class RuleConfig
      def initialize(@client : Zap::Client)
      end

      # Actions
      def reset_all_rule_config_values : JSON::Any
        @client.request("/JSON/ruleConfig/action/resetAllRuleConfigValues/")
      end

      def reset_rule_config_value(key : String) : JSON::Any
        @client.request("/JSON/ruleConfig/action/resetRuleConfigValue/", {"key" => key})
      end

      # Sets `key` to `value`. Omitting `value` clears the configured value,
      # which is why it is only sent when non-empty.
      def set_rule_config_value(key : String, value : String = "") : JSON::Any
        params = {"key" => key}
        params["value"] = value unless value.empty?
        @client.request("/JSON/ruleConfig/action/setRuleConfigValue/", params)
      end

      # Views
      def all_rule_configs : JSON::Any
        @client.request("/JSON/ruleConfig/view/allRuleConfigs/")
      end

      def rule_config_value(key : String) : JSON::Any
        @client.request("/JSON/ruleConfig/view/ruleConfigValue/", {"key" => key})
      end
    end
  end
end
