module Zap
  module Api
    # The "client" add-on: client-side (browser) events, objects and Zest
    # recordings reported by ZAP's browser extension.
    class Client
      def initialize(@client : Zap::Client)
      end

      # Actions
      #
      # Each report action takes the corresponding JSON document as a string;
      # ZAP rejects the call without it.
      def export_client_map(path_yaml : String) : JSON::Any
        @client.request("/JSON/client/action/exportClientMap/", {"pathYaml" => path_yaml})
      end

      def report_event(event_json : String) : JSON::Any
        @client.request("/JSON/client/action/reportEvent/", {"eventJson" => event_json})
      end

      def report_object(object_json : String) : JSON::Any
        @client.request("/JSON/client/action/reportObject/", {"objectJson" => object_json})
      end

      def report_zest_script(script_json : String) : JSON::Any
        @client.request("/JSON/client/action/reportZestScript/", {"scriptJson" => script_json})
      end

      def report_zest_statement(statement_json : String) : JSON::Any
        @client.request("/JSON/client/action/reportZestStatement/", {"statementJson" => statement_json})
      end

      def set_option_pscan_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/client/action/setOptionPscanEnabled/", {"Boolean" => enabled.to_s})
      end

      # Views
      def option_pscan_enabled : JSON::Any
        @client.request("/JSON/client/view/optionPscanEnabled/")
      end

      def option_pscan_rules_disabled : JSON::Any
        @client.request("/JSON/client/view/optionPscanRulesDisabled/")
      end
    end
  end
end
