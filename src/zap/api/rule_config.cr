module Zap
  module Api
    class RuleConfig
      def initialize(@client : Zap::Client)
      end

      def reset_all_rule_config_values : JSON::Any
        @client.request("/JSON/ruleConfig/action/resetAllRuleConfigValues/")
      end

      def reset_rule_config_value : JSON::Any
        @client.request("/JSON/ruleConfig/action/resetRuleConfigValue/")
      end

      def set_rule_config_value : JSON::Any
        @client.request("/JSON/ruleConfig/action/setRuleConfigValue/")
      end

      def all_rule_configs : JSON::Any
        @client.request("/JSON/ruleConfig/view/allRuleConfigs/")
      end

      def rule_config_value : JSON::Any
        @client.request("/JSON/ruleConfig/view/ruleConfigValue/")
      end
    end
  end
end
