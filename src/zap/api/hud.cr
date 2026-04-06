module Zap
  module Api
    class Hud
      def initialize(@client : Zap::Client)
      end

      def log : JSON::Any
        @client.request("/JSON/hud/action/log/")
      end

      def record_request : JSON::Any
        @client.request("/JSON/hud/action/recordRequest/")
      end

      def reset_tutorial_tasks : JSON::Any
        @client.request("/JSON/hud/action/resetTutorialTasks/")
      end

      def set_option_base_directory : JSON::Any
        @client.request("/JSON/hud/action/setOptionBaseDirectory/")
      end

      def set_option_development_mode : JSON::Any
        @client.request("/JSON/hud/action/setOptionDevelopmentMode/")
      end

      def set_option_enable_on_domain_msgs : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnableOnDomainMsgs/")
      end

      def set_option_enabled_for_daemon : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnabledForDaemon/")
      end

      def set_option_enabled_for_desktop : JSON::Any
        @client.request("/JSON/hud/action/setOptionEnabledForDesktop/")
      end

      def set_option_in_scope_only : JSON::Any
        @client.request("/JSON/hud/action/setOptionInScopeOnly/")
      end

      def set_option_remove_csp : JSON::Any
        @client.request("/JSON/hud/action/setOptionRemoveCSP/")
      end

      def set_option_show_welcome_screen : JSON::Any
        @client.request("/JSON/hud/action/setOptionShowWelcomeScreen/")
      end

      def set_option_skip_tutorial_tasks : JSON::Any
        @client.request("/JSON/hud/action/setOptionSkipTutorialTasks/")
      end

      def set_option_tutorial_task_done : JSON::Any
        @client.request("/JSON/hud/action/setOptionTutorialTaskDone/")
      end

      def set_option_tutorial_test_mode : JSON::Any
        @client.request("/JSON/hud/action/setOptionTutorialTestMode/")
      end

      def set_ui_option : JSON::Any
        @client.request("/JSON/hud/action/setUiOption/")
      end

      def changes_in_html : String
        @client.request_other("/OTHER/hud/other/changesInHtml/")
      end

      def get_ui_option : JSON::Any
        @client.request("/JSON/hud/view/getUiOption/")
      end

      def heartbeat : JSON::Any
        @client.request("/JSON/hud/view/heartbeat/")
      end

      def hud_alert_data : JSON::Any
        @client.request("/JSON/hud/view/hudAlertData/")
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
