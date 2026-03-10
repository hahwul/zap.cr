module Zap
  module Api
    class RuleConfig
      def initialize(@client : Zap::Client)
      end

      def reset_all_rule_config_values : JSON::Any
        params = {} of String => String
        @client.request("/JSON/ruleConfig/action/resetAllRuleConfigValues/", params)
      end

      def reset_rule_config_value : JSON::Any
        params = {} of String => String
        @client.request("/JSON/ruleConfig/action/resetRuleConfigValue/", params)
      end

      def set_rule_config_value : JSON::Any
        params = {} of String => String
        @client.request("/JSON/ruleConfig/action/setRuleConfigValue/", params)
      end

      def all_rule_configs : JSON::Any
        params = {} of String => String
        @client.request("/JSON/ruleConfig/view/allRuleConfigs/", params)
      end

      def rule_config_value : JSON::Any
        params = {} of String => String
        @client.request("/JSON/ruleConfig/view/ruleConfigValue/", params)
      end
    end
  end
end
