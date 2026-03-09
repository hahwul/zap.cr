module Zap
  module Api
    class Replacer
      def initialize(@client : Zap::Client)
      end

      def rules : JSON::Any
        @client.request("/JSON/replacer/view/rules/")
      end

      def add_rule(description : String, enabled : Bool, match_type : String, match_regex : Bool, match_string : String, replacement : String = "", initiators : String = "") : JSON::Any
        params = {
          "description" => description, "enabled" => enabled.to_s,
          "matchType" => match_type, "matchRegex" => match_regex.to_s,
          "matchString" => match_string,
        }
        params["replacement"] = replacement unless replacement.empty?
        params["initiators"] = initiators unless initiators.empty?
        @client.request("/JSON/replacer/action/addRule/", params)
      end

      def remove_rule(description : String) : JSON::Any
        @client.request("/JSON/replacer/action/removeRule/", {"description" => description})
      end

      def set_enabled(description : String, enabled : Bool) : JSON::Any
        @client.request("/JSON/replacer/action/setEnabled/", {"description" => description, "bool" => enabled.to_s})
      end
    end
  end
end
