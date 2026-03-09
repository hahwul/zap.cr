module Zap
  module Api
    class Autoupdate
      def initialize(@client : Zap::Client)
      end

      # Views
      def latest_version_number : JSON::Any
        @client.request("/JSON/autoupdate/view/latestVersionNumber/")
      end

      def is_latest_version : JSON::Any
        @client.request("/JSON/autoupdate/view/isLatestVersion/")
      end

      def installed_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/installedAddons/")
      end

      def new_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/newAddons/")
      end

      def updated_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/updatedAddons/")
      end

      def marketplace_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/marketplaceAddons/")
      end

      def option_check_on_start : JSON::Any
        @client.request("/JSON/autoupdate/view/optionCheckOnStart/")
      end

      def option_download_new_release : JSON::Any
        @client.request("/JSON/autoupdate/view/optionDownloadNewRelease/")
      end

      def option_check_addon_updates : JSON::Any
        @client.request("/JSON/autoupdate/view/optionCheckAddonUpdates/")
      end

      def option_install_addon_updates : JSON::Any
        @client.request("/JSON/autoupdate/view/optionInstallAddonUpdates/")
      end

      def option_install_scanner_rules : JSON::Any
        @client.request("/JSON/autoupdate/view/optionInstallScannerRules/")
      end

      def option_report_release_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/optionReportReleaseAddons/")
      end

      def option_report_alpha_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/optionReportAlphaAddons/")
      end

      def option_report_beta_addons : JSON::Any
        @client.request("/JSON/autoupdate/view/optionReportBetaAddons/")
      end

      # Actions
      def download_latest_release : JSON::Any
        @client.request("/JSON/autoupdate/action/downloadLatestRelease/")
      end

      def install_addon(id : String) : JSON::Any
        @client.request("/JSON/autoupdate/action/installAddon/", {"id" => id})
      end

      def install_local_addon(file : String) : JSON::Any
        @client.request("/JSON/autoupdate/action/installLocalAddon/", {"file" => file})
      end

      def uninstall_addon(id : String) : JSON::Any
        @client.request("/JSON/autoupdate/action/uninstallAddon/", {"id" => id})
      end

      def set_option_check_on_start(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionCheckOnStart/", {"Boolean" => enabled.to_s})
      end

      def set_option_download_new_release(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionDownloadNewRelease/", {"Boolean" => enabled.to_s})
      end

      def set_option_check_addon_updates(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionCheckAddonUpdates/", {"Boolean" => enabled.to_s})
      end

      def set_option_install_addon_updates(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionInstallAddonUpdates/", {"Boolean" => enabled.to_s})
      end

      def set_option_install_scanner_rules(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionInstallScannerRules/", {"Boolean" => enabled.to_s})
      end

      def set_option_report_release_addons(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionReportReleaseAddons/", {"Boolean" => enabled.to_s})
      end

      def set_option_report_alpha_addons(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionReportAlphaAddons/", {"Boolean" => enabled.to_s})
      end

      def set_option_report_beta_addons(enabled : Bool) : JSON::Any
        @client.request("/JSON/autoupdate/action/setOptionReportBetaAddons/", {"Boolean" => enabled.to_s})
      end
    end
  end
end
