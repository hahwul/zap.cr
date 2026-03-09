module Zap
  module Api
    class Core
      def initialize(@client : Zap::Client)
      end

      # Views
      def version : JSON::Any
        @client.request("/JSON/core/view/getVersion/")
      end

      def alerts(base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request("/JSON/core/view/alerts/", params)
      end

      def alerts_summary(base_url : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        @client.request("/JSON/core/view/alertsSummary/", params)
      end

      def number_of_alerts(base_url : String = "", risk_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = risk_id.to_s if risk_id >= 0
        @client.request("/JSON/core/view/numberOfAlerts/", params)
      end

      def message(id : Int32) : JSON::Any
        @client.request("/JSON/core/view/getMessage/", {"id" => id.to_s})
      end

      def messages(base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request("/JSON/core/view/getMessages/", params)
      end

      def number_of_messages(base_url : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        @client.request("/JSON/core/view/getNumberOfMessages/", params)
      end

      def home_directory : JSON::Any
        @client.request("/JSON/core/view/homeDirectory/")
      end

      def site_tree(url : String = "") : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        @client.request("/JSON/core/view/getSiteTree/", params)
      end

      def sessions : JSON::Any
        @client.request("/JSON/core/view/sessions/")
      end

      def session_properties : JSON::Any
        @client.request("/JSON/core/view/sessionProperties/")
      end

      def excluded_from_proxy : JSON::Any
        @client.request("/JSON/core/view/getExcludedFromProxyRegexes/")
      end

      def certificate_content : JSON::Any
        @client.request("/JSON/core/view/getCertificateContent/")
      end

      def option(name : String) : JSON::Any
        @client.request("/JSON/core/view/getOption/", {"name" => name})
      end

      def option_default_user_agent : JSON::Any
        @client.request("/JSON/core/view/optionDefaultUserAgent/")
      end

      def option_timeout_in_secs : JSON::Any
        @client.request("/JSON/core/view/optionTimeoutInSecs/")
      end

      def option_http_state : JSON::Any
        @client.request("/JSON/core/view/optionHttpState/")
      end

      def option_proxy_chain_name : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainName/")
      end

      def option_proxy_chain_port : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainPort/")
      end

      def option_maximum_alert_instances : JSON::Any
        @client.request("/JSON/core/view/optionMaximumAlertInstances/")
      end

      # Actions
      def new_session(name : String = "", overwrite : Bool = false) : JSON::Any
        params = {} of String => String
        params["name"] = name unless name.empty?
        params["overwrite"] = overwrite.to_s
        @client.request("/JSON/core/action/newSession/", params)
      end

      def save_session(name : String, overwrite : Bool = false) : JSON::Any
        @client.request("/JSON/core/action/saveSession/", {"name" => name, "overwrite" => overwrite.to_s})
      end

      def snapshot_session(name : String = "", overwrite : Bool = false) : JSON::Any
        params = {} of String => String
        params["name"] = name unless name.empty?
        params["overwrite"] = overwrite.to_s
        @client.request("/JSON/core/action/snapshotSession/", params)
      end

      def delete_session(name : String) : JSON::Any
        @client.request("/JSON/core/action/deleteSession/", {"name" => name})
      end

      def access_url(url : String, follow_redirects : Bool = true) : JSON::Any
        @client.request("/JSON/core/action/accessUrl/", {"url" => url, "followRedirects" => follow_redirects.to_s})
      end

      def shutdown : JSON::Any
        @client.request("/JSON/core/action/shutdown/")
      end

      def exclude_from_proxy(regex : String) : JSON::Any
        @client.request("/JSON/core/action/excludeFromProxy/", {"regex" => regex})
      end

      def clear_excluded_from_proxy : JSON::Any
        @client.request("/JSON/core/action/clearExcludedFromProxy/")
      end

      def generate_root_ca : JSON::Any
        @client.request("/JSON/core/action/generateRootCA/")
      end

      def add_session_token(site : String, name : String) : JSON::Any
        @client.request("/JSON/core/action/addSessionToken/", {"site" => site, "name" => name})
      end

      def remove_session_token(site : String, name : String) : JSON::Any
        @client.request("/JSON/core/action/removeSessionToken/", {"site" => site, "name" => name})
      end

      def set_option_default_user_agent(user_agent : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionDefaultUserAgent/", {"String" => user_agent})
      end

      def set_option_timeout_in_secs(timeout : Int32) : JSON::Any
        @client.request("/JSON/core/action/setOptionTimeoutInSecs/", {"Integer" => timeout.to_s})
      end

      def set_option_maximum_alert_instances(instances : Int32) : JSON::Any
        @client.request("/JSON/core/action/setOptionMaximumAlertInstances/", {"Integer" => instances.to_s})
      end

      def delete_all_alerts : JSON::Any
        @client.request("/JSON/core/action/deleteAllAlerts/")
      end
    end
  end
end
