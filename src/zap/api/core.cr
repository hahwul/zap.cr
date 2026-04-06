module Zap
  module Api
    class Core
      def initialize(@client : Zap::Client)
      end

      # Views
      def version : JSON::Any
        @client.request("/JSON/core/view/version/")
      end

      def alerts(base_url : String = "", start : String = "", count : String = "", risk_id : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start unless start.empty?
        params["count"] = count unless count.empty?
        params["riskId"] = risk_id unless risk_id.empty?
        @client.request("/JSON/core/view/alerts/", params)
      end

      def alerts_summary(base_url : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        @client.request("/JSON/core/view/alertsSummary/", params)
      end

      def number_of_alerts(base_url : String = "", risk_id : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["riskId"] = risk_id unless risk_id.empty?
        @client.request("/JSON/core/view/numberOfAlerts/", params)
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

      def add_proxy_chain_excluded_domain(value : String, is_regex : Bool? = nil, is_enabled : Bool? = nil) : JSON::Any
        params = {} of String => String
        params["value"] = value
        params["isRegex"] = is_regex.to_s unless is_regex.nil?
        params["isEnabled"] = is_enabled.to_s unless is_enabled.nil?
        @client.request("/JSON/core/action/addProxyChainExcludedDomain/", params)
      end

      def create_sbom_zip(file_path : String) : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path
        @client.request("/JSON/core/action/createSbomZip/", params)
      end

      def delete_alert(id : String) : JSON::Any
        params = {} of String => String
        params["id"] = id
        @client.request("/JSON/core/action/deleteAlert/", params)
      end

      def delete_site_node(url : String, method_param : String = "", post_data : String = "") : JSON::Any
        params = {} of String => String
        params["url"] = url
        params["method"] = method_param unless method_param.empty?
        params["postData"] = post_data unless post_data.empty?
        @client.request("/JSON/core/action/deleteSiteNode/", params)
      end

      def disable_all_proxy_chain_excluded_domains : JSON::Any
        @client.request("/JSON/core/action/disableAllProxyChainExcludedDomains/")
      end

      def disable_client_certificate : JSON::Any
        @client.request("/JSON/core/action/disableClientCertificate/")
      end

      def enable_all_proxy_chain_excluded_domains : JSON::Any
        @client.request("/JSON/core/action/enableAllProxyChainExcludedDomains/")
      end

      def enable_pkcs12_client_certificate(file_path : String, password : String, index : String = "") : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path
        params["password"] = password
        params["index"] = index unless index.empty?
        @client.request("/JSON/core/action/enablePKCS12ClientCertificate/", params)
      end

      def load_session(name : String) : JSON::Any
        params = {} of String => String
        params["name"] = name
        @client.request("/JSON/core/action/loadSession/", params)
      end

      def modify_proxy_chain_excluded_domain(idx : String, value : String = "", is_regex : Bool? = nil, is_enabled : Bool? = nil) : JSON::Any
        params = {} of String => String
        params["idx"] = idx
        params["value"] = value unless value.empty?
        params["isRegex"] = is_regex.to_s unless is_regex.nil?
        params["isEnabled"] = is_enabled.to_s unless is_enabled.nil?
        @client.request("/JSON/core/action/modifyProxyChainExcludedDomain/", params)
      end

      def remove_proxy_chain_excluded_domain(idx : String) : JSON::Any
        params = {} of String => String
        params["idx"] = idx
        @client.request("/JSON/core/action/removeProxyChainExcludedDomain/", params)
      end

      def run_garbage_collection : JSON::Any
        @client.request("/JSON/core/action/runGarbageCollection/")
      end

      def send_request(request : String, follow_redirects : Bool? = nil) : JSON::Any
        params = {} of String => String
        params["request"] = request
        params["followRedirects"] = follow_redirects.to_s unless follow_redirects.nil?
        @client.request("/JSON/core/action/sendRequest/", params)
      end

      def set_home_directory(dir : String) : JSON::Any
        params = {} of String => String
        params["dir"] = dir
        @client.request("/JSON/core/action/setHomeDirectory/", params)
      end

      def set_log_level(name : String, log_level : String) : JSON::Any
        params = {} of String => String
        params["name"] = name
        params["logLevel"] = log_level
        @client.request("/JSON/core/action/setLogLevel/", params)
      end

      def set_mode(mode : String) : JSON::Any
        params = {} of String => String
        params["mode"] = mode
        @client.request("/JSON/core/action/setMode/", params)
      end

      def set_option_alert_overrides_file_path(file_path : String = "") : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path unless file_path.empty?
        @client.request("/JSON/core/action/setOptionAlertOverridesFilePath/", params)
      end

      def set_option_dns_ttl_successful_queries(value : Int32) : JSON::Any
        @client.request("/JSON/core/action/setOptionDnsTtlSuccessfulQueries/", {"Integer" => value.to_s})
      end

      def set_option_http_state_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionHttpStateEnabled/", {"Boolean" => enabled.to_s})
      end

      def set_option_merge_related_alerts(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionMergeRelatedAlerts/", {"enabled" => enabled.to_s})
      end

      def set_option_proxy_chain_name(name : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainName/", {"String" => name})
      end

      def set_option_proxy_chain_password(password : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainPassword/", {"String" => password})
      end

      def set_option_proxy_chain_port(port : Int32) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainPort/", {"Integer" => port.to_s})
      end

      def set_option_proxy_chain_prompt(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainPrompt/", {"Boolean" => enabled.to_s})
      end

      def set_option_proxy_chain_realm(realm : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainRealm/", {"String" => realm})
      end

      def set_option_proxy_chain_skip_name(name : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainSkipName/", {"String" => name})
      end

      def set_option_proxy_chain_user_name(username : String) : JSON::Any
        @client.request("/JSON/core/action/setOptionProxyChainUserName/", {"String" => username})
      end

      def set_option_single_cookie_request_header(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionSingleCookieRequestHeader/", {"Boolean" => enabled.to_s})
      end

      def set_option_use_proxy_chain(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionUseProxyChain/", {"Boolean" => enabled.to_s})
      end

      def set_option_use_proxy_chain_auth(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionUseProxyChainAuth/", {"Boolean" => enabled.to_s})
      end

      def set_option_use_socks_proxy(enabled : Bool) : JSON::Any
        @client.request("/JSON/core/action/setOptionUseSocksProxy/", {"Boolean" => enabled.to_s})
      end

      def file_download(file_name : String) : String
        params = {} of String => String
        params["fileName"] = file_name
        @client.request_other("/OTHER/core/other/fileDownload/", params)
      end

      def file_upload(file_name : String, file_contents : String) : String
        params = {} of String => String
        params["fileName"] = file_name
        params["fileContents"] = file_contents
        @client.request_other("/OTHER/core/other/fileUpload/", params)
      end

      def htmlreport : String
        @client.request_other("/OTHER/core/other/htmlreport/")
      end

      def jsonreport : String
        @client.request_other("/OTHER/core/other/jsonreport/")
      end

      def mdreport : String
        @client.request_other("/OTHER/core/other/mdreport/")
      end

      def message_har(id : String) : String
        params = {} of String => String
        params["id"] = id
        @client.request_other("/OTHER/core/other/messageHar/", params)
      end

      def messages_har(baseurl : String = "", start : String = "", count : String = "") : String
        params = {} of String => String
        params["baseurl"] = baseurl unless baseurl.empty?
        params["start"] = start unless start.empty?
        params["count"] = count unless count.empty?
        @client.request_other("/OTHER/core/other/messagesHar/", params)
      end

      def messages_har_by_id(ids : String) : String
        params = {} of String => String
        params["ids"] = ids
        @client.request_other("/OTHER/core/other/messagesHarById/", params)
      end

      def proxy_pac : String
        @client.request_other("/OTHER/core/other/proxy.pac/")
      end

      def rootcert : String
        @client.request_other("/OTHER/core/other/rootcert/")
      end

      def send_har_request(request : String, follow_redirects : Bool? = nil) : String
        params = {} of String => String
        params["request"] = request
        params["followRedirects"] = follow_redirects.to_s unless follow_redirects.nil?
        @client.request_other("/OTHER/core/other/sendHarRequest/", params)
      end

      def setproxy(proxy : String) : String
        params = {} of String => String
        params["proxy"] = proxy
        @client.request_other("/OTHER/core/other/setproxy/", params)
      end

      def xmlreport : String
        @client.request_other("/OTHER/core/other/xmlreport/")
      end

      def alert(id : String) : JSON::Any
        params = {} of String => String
        params["id"] = id
        @client.request("/JSON/core/view/alert/", params)
      end

      def child_nodes(url : String = "") : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        @client.request("/JSON/core/view/childNodes/", params)
      end

      def excluded_from_proxy : JSON::Any
        @client.request("/JSON/core/view/excludedFromProxy/")
      end

      def get_log_level(name : String = "") : JSON::Any
        params = {} of String => String
        params["name"] = name unless name.empty?
        @client.request("/JSON/core/view/getLogLevel/", params)
      end

      def hosts : JSON::Any
        @client.request("/JSON/core/view/hosts/")
      end

      def message(id : String) : JSON::Any
        params = {} of String => String
        params["id"] = id
        @client.request("/JSON/core/view/message/", params)
      end

      def messages(baseurl : String = "", start : String = "", count : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = baseurl unless baseurl.empty?
        params["start"] = start unless start.empty?
        params["count"] = count unless count.empty?
        @client.request("/JSON/core/view/messages/", params)
      end

      def messages_by_id(ids : String) : JSON::Any
        params = {} of String => String
        params["ids"] = ids
        @client.request("/JSON/core/view/messagesById/", params)
      end

      def mode : JSON::Any
        @client.request("/JSON/core/view/mode/")
      end

      def number_of_messages(baseurl : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = baseurl unless baseurl.empty?
        @client.request("/JSON/core/view/numberOfMessages/", params)
      end

      def option_alert_overrides_file_path : JSON::Any
        @client.request("/JSON/core/view/optionAlertOverridesFilePath/")
      end

      def option_dns_ttl_successful_queries : JSON::Any
        @client.request("/JSON/core/view/optionDnsTtlSuccessfulQueries/")
      end

      def option_http_state_enabled : JSON::Any
        @client.request("/JSON/core/view/optionHttpStateEnabled/")
      end

      def option_merge_related_alerts : JSON::Any
        @client.request("/JSON/core/view/optionMergeRelatedAlerts/")
      end

      def option_proxy_chain_password : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainPassword/")
      end

      def option_proxy_chain_prompt : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainPrompt/")
      end

      def option_proxy_chain_realm : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainRealm/")
      end

      def option_proxy_chain_skip_name : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainSkipName/")
      end

      def option_proxy_chain_user_name : JSON::Any
        @client.request("/JSON/core/view/optionProxyChainUserName/")
      end

      def option_proxy_excluded_domains : JSON::Any
        @client.request("/JSON/core/view/optionProxyExcludedDomains/")
      end

      def option_proxy_excluded_domains_enabled : JSON::Any
        @client.request("/JSON/core/view/optionProxyExcludedDomainsEnabled/")
      end

      def option_single_cookie_request_header : JSON::Any
        @client.request("/JSON/core/view/optionSingleCookieRequestHeader/")
      end

      def option_use_proxy_chain : JSON::Any
        @client.request("/JSON/core/view/optionUseProxyChain/")
      end

      def option_use_proxy_chain_auth : JSON::Any
        @client.request("/JSON/core/view/optionUseProxyChainAuth/")
      end

      def option_use_socks_proxy : JSON::Any
        @client.request("/JSON/core/view/optionUseSocksProxy/")
      end

      def proxy_chain_excluded_domains : JSON::Any
        @client.request("/JSON/core/view/proxyChainExcludedDomains/")
      end

      def session_location : JSON::Any
        @client.request("/JSON/core/view/sessionLocation/")
      end

      def sites : JSON::Any
        @client.request("/JSON/core/view/sites/")
      end

      def urls(baseurl : String = "") : JSON::Any
        params = {} of String => String
        params["baseurl"] = baseurl unless baseurl.empty?
        @client.request("/JSON/core/view/urls/", params)
      end

      def zap_home_path : JSON::Any
        @client.request("/JSON/core/view/zapHomePath/")
      end
    end
  end
end
