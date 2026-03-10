module Zap
  module Api
    class Hud
      def initialize(@client : Zap::Client)
      end

      def log : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/log/", params)
      end

      def record_request : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/recordRequest/", params)
      end

      def reset_tutorial_tasks : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/resetTutorialTasks/", params)
      end

      def set_option_base_directory : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionBaseDirectory/", params)
      end

      def set_option_development_mode : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionDevelopmentMode/", params)
      end

      def set_option_enable_on_domain_msgs : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionEnableOnDomainMsgs/", params)
      end

      def set_option_enabled_for_daemon : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionEnabledForDaemon/", params)
      end

      def set_option_enabled_for_desktop : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionEnabledForDesktop/", params)
      end

      def set_option_in_scope_only : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionInScopeOnly/", params)
      end

      def set_option_remove_csp : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionRemoveCSP/", params)
      end

      def set_option_show_welcome_screen : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionShowWelcomeScreen/", params)
      end

      def set_option_skip_tutorial_tasks : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionSkipTutorialTasks/", params)
      end

      def set_option_tutorial_task_done : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionTutorialTaskDone/", params)
      end

      def set_option_tutorial_test_mode : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setOptionTutorialTestMode/", params)
      end

      def set_ui_option : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/action/setUiOption/", params)
      end

      def changes_in_html : String
        params = {} of String => String
        @client.request_other("/OTHER/hud/other/changesInHtml/", params)
      end

      def get_ui_option : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/getUiOption/", params)
      end

      def heartbeat : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/heartbeat/", params)
      end

      def hud_alert_data : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/hudAlertData/", params)
      end

      def option_allow_unsafe_eval : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionAllowUnsafeEval/", params)
      end

      def option_base_directory : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionBaseDirectory/", params)
      end

      def option_development_mode : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionDevelopmentMode/", params)
      end

      def option_enable_on_domain_msgs : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionEnableOnDomainMsgs/", params)
      end

      def option_enable_telemetry : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionEnableTelemetry/", params)
      end

      def option_enabled_for_daemon : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionEnabledForDaemon/", params)
      end

      def option_enabled_for_desktop : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionEnabledForDesktop/", params)
      end

      def option_in_scope_only : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionInScopeOnly/", params)
      end

      def option_remove_csp : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionRemoveCSP/", params)
      end

      def option_show_welcome_screen : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionShowWelcomeScreen/", params)
      end

      def option_skip_tutorial_tasks : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionSkipTutorialTasks/", params)
      end

      def option_tutorial_host : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionTutorialHost/", params)
      end

      def option_tutorial_port : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionTutorialPort/", params)
      end

      def option_tutorial_tasks_done : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionTutorialTasksDone/", params)
      end

      def option_tutorial_test_mode : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionTutorialTestMode/", params)
      end

      def option_tutorial_updates : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/optionTutorialUpdates/", params)
      end

      def tutorial_updates : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/tutorialUpdates/", params)
      end

      def upgraded_domains : JSON::Any
        params = {} of String => String
        @client.request("/JSON/hud/view/upgradedDomains/", params)
      end
    end
  end
end
