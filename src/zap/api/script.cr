module Zap
  module Api
    class Script
      def initialize(@client : Zap::Client)
      end

      # Views
      def list : JSON::Any
        @client.request("/JSON/script/view/listScripts/")
      end

      def engines : JSON::Any
        @client.request("/JSON/script/view/listEngines/")
      end

      def types : JSON::Any
        @client.request("/JSON/script/view/listTypes/")
      end

      def global_var(name : String) : JSON::Any
        @client.request("/JSON/script/view/globalVar/", {"varKey" => name})
      end

      def global_vars : JSON::Any
        @client.request("/JSON/script/view/globalVars/")
      end

      def script_var(script_name : String, var_name : String) : JSON::Any
        @client.request("/JSON/script/view/scriptVar/", {"scriptName" => script_name, "varKey" => var_name})
      end

      def script_vars(script_name : String) : JSON::Any
        @client.request("/JSON/script/view/scriptVars/", {"scriptName" => script_name})
      end

      # Actions
      def load(name : String, script_type : String, engine : String, file_name : String, description : String = "") : JSON::Any
        params = {"scriptName" => name, "scriptType" => script_type, "scriptEngine" => engine, "fileName" => file_name}
        params["scriptDescription"] = description unless description.empty?
        @client.request("/JSON/script/action/load/", params)
      end

      def remove(name : String) : JSON::Any
        @client.request("/JSON/script/action/remove/", {"scriptName" => name})
      end

      def run(name : String) : JSON::Any
        @client.request("/JSON/script/action/runStandAloneScript/", {"scriptName" => name})
      end

      def enable(name : String) : JSON::Any
        @client.request("/JSON/script/action/enable/", {"scriptName" => name})
      end

      def disable(name : String) : JSON::Any
        @client.request("/JSON/script/action/disable/", {"scriptName" => name})
      end

      def set_global_var(name : String, value : String) : JSON::Any
        @client.request("/JSON/script/action/setGlobalVar/", {"varKey" => name, "varValue" => value})
      end

      def clear_global_var(name : String) : JSON::Any
        @client.request("/JSON/script/action/clearGlobalVar/", {"varKey" => name})
      end

      def clear_global_vars : JSON::Any
        @client.request("/JSON/script/action/clearGlobalVars/")
      end

      def set_script_var(script_name : String, var_name : String, value : String) : JSON::Any
        @client.request("/JSON/script/action/setScriptVar/", {"scriptName" => script_name, "varKey" => var_name, "varValue" => value})
      end

      def clear_script_var(script_name : String, var_name : String) : JSON::Any
        @client.request("/JSON/script/action/clearScriptVar/", {"scriptName" => script_name, "varKey" => var_name})
      end

      def clear_script_vars(script_name : String) : JSON::Any
        @client.request("/JSON/script/action/clearScriptVars/", {"scriptName" => script_name})
      end

      def clear_global_custom_var(var_key : String) : JSON::Any
        @client.request("/JSON/script/action/clearGlobalCustomVar/", {"varKey" => var_key})
      end

      def clear_script_custom_var(script_name : String, var_key : String) : JSON::Any
        @client.request("/JSON/script/action/clearScriptCustomVar/", {"scriptName" => script_name, "varKey" => var_key})
      end

      def global_custom_var(var_key : String) : JSON::Any
        @client.request("/JSON/script/view/globalCustomVar/", {"varKey" => var_key})
      end

      def global_custom_vars : JSON::Any
        @client.request("/JSON/script/view/globalCustomVars/")
      end

      def script_custom_var(script_name : String, var_key : String) : JSON::Any
        @client.request("/JSON/script/view/scriptCustomVar/", {"scriptName" => script_name, "varKey" => var_key})
      end

      def script_custom_vars(script_name : String) : JSON::Any
        @client.request("/JSON/script/view/scriptCustomVars/", {"scriptName" => script_name})
      end
    end
  end
end
