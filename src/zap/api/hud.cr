module Zap
  module Api
    class Hud
      def initialize(@client : Zap::Client)
      end

      # Every action below takes the parameter ZAP declares as mandatory for
      # it; the option setters use the generic `String` / `Boolean` names ZAP
      # gives `setOption*` actions, as elsewhere in this library.
      def log(record : String) : JSON::Any
        @client.request("/JSON/hud/action/log/", {"record" => record})
      end

      def record_request(header : String, body : String) : JSON::Any
        @client.request("/JSON/hud/action/recordRequest/", {"header" => header, "body" => body})
      end

      def reset_tutorial_tasks : JSON::Any
        @client.request("/JSON/hud/action/resetTutorialTasks/")
      end

      def set_option_base_directory(directory : String) : JSON::Any
        @client.request("/JSON/hud/action/setOptionBaseDirectory/", {"String" => directory})
      end

      def set_option_development_mode(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionDevelopmentMode/", {"Boolean" => enabled.to_s})
      end

      def set_option_enable_on_domain_msgs(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnableOnDomainMsgs/", {"Boolean" => enabled.to_s})
      end

      def set_option_enabled_for_daemon(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnabledForDaemon/", {"Boolean" => enabled.to_s})
      end

      def set_option_enabled_for_desktop(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnabledForDesktop/", {"Boolean" => enabled.to_s})
      end

      def set_option_in_scope_only(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionInScopeOnly/", {"Boolean" => enabled.to_s})
      end

      def set_option_remove_csp(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionRemoveCSP/", {"Boolean" => enabled.to_s})
      end

      def set_option_show_welcome_screen(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionShowWelcomeScreen/", {"Boolean" => enabled.to_s})
      end

      def set_option_skip_tutorial_tasks(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionSkipTutorialTasks/", {"Boolean" => enabled.to_s})
      end

      def set_option_tutorial_task_done(task : String) : JSON::Any
        @client.request("/JSON/hud/action/setOptionTutorialTaskDone/", {"String" => task})
      end

      def set_option_tutorial_test_mode(enabled : Bool) : JSON::Any
        @client.request("/JSON/hud/action/setOptionTutorialTestMode/", {"Boolean" => enabled.to_s})
      end

      # `value` is optional: omitting it clears the stored UI option.
      def set_ui_option(key : String, value : String = "") : JSON::Any
        params = {"key" => key}
        params["value"] = value unless value.empty?
        @client.request("/JSON/hud/action/setUiOption/", params)
      end

      def changes_in_html : String
        @client.request_other("/OTHER/hud/other/changesInHtml/")
      end

      def get_ui_option(key : String) : JSON::Any
        @client.request("/JSON/hud/view/getUiOption/", {"key" => key})
      end

      def heartbeat : JSON::Any
        @client.request("/JSON/hud/view/heartbeat/")
      end

      def hud_alert_data(url : String) : JSON::Any
        @client.request("/JSON/hud/view/hudAlertData/", {"url" => url})
      end

      def option_allow_unsafe_eval : JSON::Any
        @client.request("/JSON/hud/view/optionAllowUnsafeEval/")
      end

      def option_base_directory : JSON::Any
        @client.request("/JSON/hud/view/optionBaseDirectory/")
      end

      def option_development_mode : JSON::Any
        @client.request("/JSON/hud/view/optionDevelopmentMode/")
      end

      def option_enable_on_domain_msgs : JSON::Any
        @client.request("/JSON/hud/view/optionEnableOnDomainMsgs/")
      end

      def option_enable_telemetry : JSON::Any
        @client.request("/JSON/hud/view/optionEnableTelemetry/")
      end

      def option_enabled_for_daemon : JSON::Any
        @client.request("/JSON/hud/view/optionEnabledForDaemon/")
      end

      def option_enabled_for_desktop : JSON::Any
        @client.request("/JSON/hud/view/optionEnabledForDesktop/")
      end

      def option_in_scope_only : JSON::Any
        @client.request("/JSON/hud/view/optionInScopeOnly/")
      end

      def option_remove_csp : JSON::Any
        @client.request("/JSON/hud/view/optionRemoveCSP/")
      end

      def option_show_welcome_screen : JSON::Any
        @client.request("/JSON/hud/view/optionShowWelcomeScreen/")
      end

      def option_skip_tutorial_tasks : JSON::Any
        @client.request("/JSON/hud/view/optionSkipTutorialTasks/")
      end

      def option_tutorial_host : JSON::Any
        @client.request("/JSON/hud/view/optionTutorialHost/")
      end

      def option_tutorial_port : JSON::Any
        @client.request("/JSON/hud/view/optionTutorialPort/")
      end

      def option_tutorial_tasks_done : JSON::Any
        @client.request("/JSON/hud/view/optionTutorialTasksDone/")
      end

      def option_tutorial_test_mode : JSON::Any
        @client.request("/JSON/hud/view/optionTutorialTestMode/")
      end

      def option_tutorial_updates : JSON::Any
        @client.request("/JSON/hud/view/optionTutorialUpdates/")
      end

      def tutorial_updates : JSON::Any
        @client.request("/JSON/hud/view/tutorialUpdates/")
      end

      def upgraded_domains : JSON::Any
        @client.request("/JSON/hud/view/upgradedDomains/")
      end
    end
  end
end
