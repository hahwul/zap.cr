module Zap
  module Api
    class Ascan
      def initialize(@client : Zap::Client)
      end

      # Actions
      def scan(url : String = "", recurse : Bool = true, in_scope_only : Bool = false, scan_policy_name : String = "", method : String = "", post_data : String = "", context_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["recurse"] = recurse.to_s
        params["inScopeOnly"] = in_scope_only.to_s
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        params["method"] = method unless method.empty?
        params["postData"] = post_data unless post_data.empty?
        params["contextId"] = context_id.to_s if context_id >= 0
        @client.request("/JSON/ascan/action/scan/", params)
      end

      def scan_as_user(url : String, context_id : Int32, user_id : Int32, recurse : Bool = true, scan_policy_name : String = "", method : String = "", post_data : String = "") : JSON::Any
        params = {"url" => url, "contextId" => context_id.to_s, "userId" => user_id.to_s, "recurse" => recurse.to_s}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        params["method"] = method unless method.empty?
        params["postData"] = post_data unless post_data.empty?
        @client.request("/JSON/ascan/action/scanAsUser/", params)
      end

      def pause(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/pause/", {"scanId" => scan_id.to_s})
      end

      def pause_all : JSON::Any
        @client.request("/JSON/ascan/action/pauseAllScans/")
      end

      def resume(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/resume/", {"scanId" => scan_id.to_s})
      end

      def resume_all : JSON::Any
        @client.request("/JSON/ascan/action/resumeAllScans/")
      end

      def stop(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/stop/", {"scanId" => scan_id.to_s})
      end

      def stop_all : JSON::Any
        @client.request("/JSON/ascan/action/stopAllScans/")
      end

      def remove_scan(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/removeScan/", {"scanId" => scan_id.to_s})
      end

      def remove_all_scans : JSON::Any
        @client.request("/JSON/ascan/action/removeAllScans/")
      end

      def set_enabled_policies(ids : String, scan_policy_name : String = "") : JSON::Any
        params = {"ids" => ids}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/setEnabledPolicies/", params)
      end

      def set_policy_attack_strength(id : Int32, attack_strength : String, scan_policy_name : String = "") : JSON::Any
        params = {"id" => id.to_s, "attackStrength" => attack_strength}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/setPolicyAttackStrength/", params)
      end

      def set_policy_alert_threshold(id : Int32, alert_threshold : String, scan_policy_name : String = "") : JSON::Any
        params = {"id" => id.to_s, "alertThreshold" => alert_threshold}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/setPolicyAlertThreshold/", params)
      end

      def set_scanner_attack_strength(id : Int32, attack_strength : String, scan_policy_name : String = "") : JSON::Any
        params = {"id" => id.to_s, "attackStrength" => attack_strength}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/setScannerAttackStrength/", params)
      end

      def set_scanner_alert_threshold(id : Int32, alert_threshold : String, scan_policy_name : String = "") : JSON::Any
        params = {"id" => id.to_s, "alertThreshold" => alert_threshold}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/setScannerAlertThreshold/", params)
      end

      def enable_scanners(ids : String, scan_policy_name : String = "") : JSON::Any
        params = {"ids" => ids}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/enableScanners/", params)
      end

      def disable_scanners(ids : String, scan_policy_name : String = "") : JSON::Any
        params = {"ids" => ids}
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/disableScanners/", params)
      end

      def enable_all_scanners(scan_policy_name : String = "") : JSON::Any
        params = {} of String => String
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/enableAllScanners/", params)
      end

      def disable_all_scanners(scan_policy_name : String = "") : JSON::Any
        params = {} of String => String
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        @client.request("/JSON/ascan/action/disableAllScanners/", params)
      end

      def add_scan_policy(name : String, alert_threshold : String = "", attack_strength : String = "") : JSON::Any
        params = {"scanPolicyName" => name}
        params["alertThreshold"] = alert_threshold unless alert_threshold.empty?
        params["attackStrength"] = attack_strength unless attack_strength.empty?
        @client.request("/JSON/ascan/action/addScanPolicy/", params)
      end

      def remove_scan_policy(name : String) : JSON::Any
        @client.request("/JSON/ascan/action/removeScanPolicy/", {"scanPolicyName" => name})
      end

      def set_option_max_scans_in_ui(max : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/setOptionMaxScansInUI/", {"Integer" => max.to_s})
      end

      def set_option_thread_per_host(threads : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/setOptionThreadPerHost/", {"Integer" => threads.to_s})
      end

      def set_option_host_per_scan(hosts : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/setOptionHostPerScan/", {"Integer" => hosts.to_s})
      end

      def set_option_max_results_to_list(max : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/setOptionMaxResultsToList/", {"Integer" => max.to_s})
      end

      def set_option_delay_in_ms(delay : Int32) : JSON::Any
        @client.request("/JSON/ascan/action/setOptionDelayInMs/", {"Integer" => delay.to_s})
      end

      def exclude_from_scan(regex : String) : JSON::Any
        @client.request("/JSON/ascan/action/excludeFromScan/", {"regex" => regex})
      end

      def clear_excluded_from_scan : JSON::Any
        @client.request("/JSON/ascan/action/clearExcludedFromScan/")
      end

      # Views
      def status(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/ascan/view/status/", params)
      end

      def scan_progress(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/ascan/view/scanProgress/", params)
      end

      def messages_ids(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/view/messagesIds/", {"scanId" => scan_id.to_s})
      end

      def alerts_ids(scan_id : Int32) : JSON::Any
        @client.request("/JSON/ascan/view/alertsIds/", {"scanId" => scan_id.to_s})
      end

      def scans : JSON::Any
        @client.request("/JSON/ascan/view/scans/")
      end

      def scan_policy_names : JSON::Any
        @client.request("/JSON/ascan/view/scanPolicyNames/")
      end

      def scanners(scan_policy_name : String = "", policy_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        params["policyId"] = policy_id.to_s if policy_id >= 0
        @client.request("/JSON/ascan/view/scanners/", params)
      end

      def policies(scan_policy_name : String = "", policy_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanPolicyName"] = scan_policy_name unless scan_policy_name.empty?
        params["policyId"] = policy_id.to_s if policy_id >= 0
        @client.request("/JSON/ascan/view/policies/", params)
      end

      def excluded_from_scan : JSON::Any
        @client.request("/JSON/ascan/view/excludedFromScan/")
      end

      def option_thread_per_host : JSON::Any
        @client.request("/JSON/ascan/view/optionThreadPerHost/")
      end

      def option_host_per_scan : JSON::Any
        @client.request("/JSON/ascan/view/optionHostPerScan/")
      end

      def option_delay_in_ms : JSON::Any
        @client.request("/JSON/ascan/view/optionDelayInMs/")
      end

      def option_max_scans_in_ui : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxScansInUI/")
      end

      def add_excluded_param(name : String, type_param : String = "", url : String = "") : JSON::Any
        params = {} of String => String
        params["name"] = name
        params["type"] = type_param unless type_param.empty?
        params["url"] = url unless url.empty?
        @client.request("/JSON/ascan/action/addExcludedParam/", params)
      end

      def import_scan_policy(path : String) : JSON::Any
        params = {} of String => String
        params["path"] = path
        @client.request("/JSON/ascan/action/importScanPolicy/", params)
      end

      def modify_excluded_param(idx : String, name : String = "", type_param : String = "", url : String = "") : JSON::Any
        params = {} of String => String
        params["idx"] = idx
        params["name"] = name unless name.empty?
        params["type"] = type_param unless type_param.empty?
        params["url"] = url unless url.empty?
        @client.request("/JSON/ascan/action/modifyExcludedParam/", params)
      end

      def remove_excluded_param(idx : String) : JSON::Any
        params = {} of String => String
        params["idx"] = idx
        @client.request("/JSON/ascan/action/removeExcludedParam/", params)
      end

      def set_option_add_query_param(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionAddQueryParam/", params)
      end

      def set_option_allow_attack_on_start(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionAllowAttackOnStart/", params)
      end

      def set_option_attack_policy(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/ascan/action/setOptionAttackPolicy/", params)
      end

      def set_option_default_policy(string : String) : JSON::Any
        params = {} of String => String
        params["String"] = string
        @client.request("/JSON/ascan/action/setOptionDefaultPolicy/", params)
      end

      def set_option_encode_cookie_values(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionEncodeCookieValues/", params)
      end

      def set_option_handle_anti_csrf_tokens(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionHandleAntiCSRFTokens/", params)
      end

      def set_option_inject_plugin_id_in_header(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionInjectPluginIdInHeader/", params)
      end

      def set_option_max_alerts_per_rule(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionMaxAlertsPerRule/", params)
      end

      def set_option_max_chart_time_in_mins(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionMaxChartTimeInMins/", params)
      end

      def set_option_max_rule_duration_in_mins(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionMaxRuleDurationInMins/", params)
      end

      def set_option_max_scan_duration_in_mins(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionMaxScanDurationInMins/", params)
      end

      def set_option_prompt_in_attack_mode(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionPromptInAttackMode/", params)
      end

      def set_option_prompt_to_clear_finished_scans(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionPromptToClearFinishedScans/", params)
      end

      def set_option_rescan_in_attack_mode(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionRescanInAttackMode/", params)
      end

      def set_option_scan_headers_all_requests(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionScanHeadersAllRequests/", params)
      end

      def set_option_scan_null_json_values(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionScanNullJsonValues/", params)
      end

      def set_option_show_advanced_dialog(boolean : String) : JSON::Any
        params = {} of String => String
        params["Boolean"] = boolean
        @client.request("/JSON/ascan/action/setOptionShowAdvancedDialog/", params)
      end

      def set_option_target_params_enabled_rpc(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionTargetParamsEnabledRPC/", params)
      end

      def set_option_target_params_injectable(integer : String) : JSON::Any
        params = {} of String => String
        params["Integer"] = integer
        @client.request("/JSON/ascan/action/setOptionTargetParamsInjectable/", params)
      end

      def skip_scanner(scan_id : String, scanner_id : String) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id
        params["scannerId"] = scanner_id
        @client.request("/JSON/ascan/action/skipScanner/", params)
      end

      def update_scan_policy(scan_policy_name : String, alert_threshold : String = "", attack_strength : String = "") : JSON::Any
        params = {} of String => String
        params["scanPolicyName"] = scan_policy_name
        params["alertThreshold"] = alert_threshold unless alert_threshold.empty?
        params["attackStrength"] = attack_strength unless attack_strength.empty?
        @client.request("/JSON/ascan/action/updateScanPolicy/", params)
      end

      def attack_mode_queue : JSON::Any
        @client.request("/JSON/ascan/view/attackModeQueue/")
      end

      def excluded_param_types : JSON::Any
        @client.request("/JSON/ascan/view/excludedParamTypes/")
      end

      def excluded_params : JSON::Any
        @client.request("/JSON/ascan/view/excludedParams/")
      end

      def option_add_query_param : JSON::Any
        @client.request("/JSON/ascan/view/optionAddQueryParam/")
      end

      def option_allow_attack_on_start : JSON::Any
        @client.request("/JSON/ascan/view/optionAllowAttackOnStart/")
      end

      def option_attack_policy : JSON::Any
        @client.request("/JSON/ascan/view/optionAttackPolicy/")
      end

      def option_default_policy : JSON::Any
        @client.request("/JSON/ascan/view/optionDefaultPolicy/")
      end

      def option_encode_cookie_values : JSON::Any
        @client.request("/JSON/ascan/view/optionEncodeCookieValues/")
      end

      def option_excluded_param_list : JSON::Any
        @client.request("/JSON/ascan/view/optionExcludedParamList/")
      end

      def option_handle_anti_csrf_tokens : JSON::Any
        @client.request("/JSON/ascan/view/optionHandleAntiCSRFTokens/")
      end

      def option_inject_plugin_id_in_header : JSON::Any
        @client.request("/JSON/ascan/view/optionInjectPluginIdInHeader/")
      end

      def option_max_alerts_per_rule : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxAlertsPerRule/")
      end

      def option_max_chart_time_in_mins : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxChartTimeInMins/")
      end

      def option_max_results_to_list : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxResultsToList/")
      end

      def option_max_rule_duration_in_mins : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxRuleDurationInMins/")
      end

      def option_max_scan_duration_in_mins : JSON::Any
        @client.request("/JSON/ascan/view/optionMaxScanDurationInMins/")
      end

      def option_prompt_in_attack_mode : JSON::Any
        @client.request("/JSON/ascan/view/optionPromptInAttackMode/")
      end

      def option_prompt_to_clear_finished_scans : JSON::Any
        @client.request("/JSON/ascan/view/optionPromptToClearFinishedScans/")
      end

      def option_rescan_in_attack_mode : JSON::Any
        @client.request("/JSON/ascan/view/optionRescanInAttackMode/")
      end

      def option_scan_headers_all_requests : JSON::Any
        @client.request("/JSON/ascan/view/optionScanHeadersAllRequests/")
      end

      def option_scan_null_json_values : JSON::Any
        @client.request("/JSON/ascan/view/optionScanNullJsonValues/")
      end

      def option_show_advanced_dialog : JSON::Any
        @client.request("/JSON/ascan/view/optionShowAdvancedDialog/")
      end

      def option_target_params_enabled_rpc : JSON::Any
        @client.request("/JSON/ascan/view/optionTargetParamsEnabledRPC/")
      end

      def option_target_params_injectable : JSON::Any
        @client.request("/JSON/ascan/view/optionTargetParamsInjectable/")
      end
    end
  end
end
