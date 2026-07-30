module Zap
  module Api
    class Spider
      def initialize(@client : Zap::Client)
      end

      # Actions
      #
      # `recurse` controls whether the spider follows links it discovers
      # (ZAP's `recurse` boolean). It defaults to `true` so a spider actually
      # crawls the site. `max_children` maps to ZAP's `maxChildren` and caps
      # the number of child nodes crawled per node; the default of `0` (the
      # parameter is omitted) means "no limit".
      def scan(url : String = "", context_name : String = "", subtree_only : Bool = false, recurse : Bool = true, max_children : Int32 = 0) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["contextName"] = context_name unless context_name.empty?
        params["subtreeOnly"] = subtree_only.to_s
        params["recurse"] = recurse.to_s
        params["maxChildren"] = max_children.to_s if max_children > 0
        @client.request("/JSON/spider/action/scan/", params)
      end

      # Spiders as an authenticated user.
      #
      # ZAP's `spider/action/scanAsUser` identifies the user numerically:
      # `contextId` and `userId` are both mandatory, and it accepts neither
      # `contextName` nor `userName`. Look the ids up with `Api::Context#context`
      # and `Api::Users#list`. This mirrors `Api::Ascan#scan_as_user`; the
      # *ajax* spider is the odd one out and does take names.
      #
      # `recurse` and `max_children` behave as in `#scan`.
      def scan_as_user(context_id : Int32, user_id : Int32, url : String = "", subtree_only : Bool = false, recurse : Bool = true, max_children : Int32 = 0) : JSON::Any
        params = {"contextId" => context_id.to_s, "userId" => user_id.to_s}
        params["url"] = url unless url.empty?
        params["subtreeOnly"] = subtree_only.to_s
        params["recurse"] = recurse.to_s
        params["maxChildren"] = max_children.to_s if max_children > 0
        @client.request("/JSON/spider/action/scanAsUser/", params)
      end

      def pause(scan_id : Int32) : JSON::Any
        @client.request("/JSON/spider/action/pause/", {"scanId" => scan_id.to_s})
      end

      def pause_all : JSON::Any
        @client.request("/JSON/spider/action/pauseAllScans/")
      end

      def resume(scan_id : Int32) : JSON::Any
        @client.request("/JSON/spider/action/resume/", {"scanId" => scan_id.to_s})
      end

      def resume_all : JSON::Any
        @client.request("/JSON/spider/action/resumeAllScans/")
      end

      def stop(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/spider/action/stop/", params)
      end

      def stop_all : JSON::Any
        @client.request("/JSON/spider/action/stopAllScans/")
      end

      def exclude_from_scan(regex : String) : JSON::Any
        @client.request("/JSON/spider/action/excludeFromScan/", {"regex" => regex})
      end

      def clear_excluded_from_scan : JSON::Any
        @client.request("/JSON/spider/action/clearExcludedFromScan/")
      end

      def add_allowed_resource(regex : String, enabled : Bool = true) : JSON::Any
        @client.request("/JSON/spider/action/addAllowedResource/", {"regex" => regex, "enabled" => enabled.to_s})
      end

      def remove_allowed_resource(regex : String) : JSON::Any
        @client.request("/JSON/spider/action/removeAllowedResource/", {"regex" => regex})
      end

      def remove_all_allowed_resources : JSON::Any
        @client.request("/JSON/spider/action/removeAllAllowedResources/")
      end

      def set_option_max_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionMaxDepth/", {"Integer" => depth.to_s})
      end

      def set_option_max_children(max : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionMaxChildren/", {"Integer" => max.to_s})
      end

      def set_option_max_duration(minutes : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionMaxDuration/", {"Integer" => minutes.to_s})
      end

      def set_option_max_parse_size_bytes(bytes : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionMaxParseSizeBytes/", {"Integer" => bytes.to_s})
      end

      def set_option_user_agent(user_agent : String) : JSON::Any
        @client.request("/JSON/spider/action/setOptionUserAgent/", {"String" => user_agent})
      end

      def set_option_parse_comments(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseComments/", {"Boolean" => enabled.to_s})
      end

      def set_option_parse_robots_txt(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseRobotsTxt/", {"Boolean" => enabled.to_s})
      end

      def set_option_post_form(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionPostForm/", {"Boolean" => enabled.to_s})
      end

      def set_option_process_form(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionProcessForm/", {"Boolean" => enabled.to_s})
      end

      def set_option_request_wait_time(millis : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionRequestWaitTime/", {"Integer" => millis.to_s})
      end

      def set_option_send_referer_header(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionSendRefererHeader/", {"Boolean" => enabled.to_s})
      end

      # Views
      def status(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/spider/view/status/", params)
      end

      # URLs found by a spider scan. ZAP's `spider/view/results` takes a single
      # optional `scanId`; omitting it reports on the most recent scan. It has
      # no pagination — the `start` / `count` this method used to accept were
      # simply dropped by the daemon.
      def results(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/spider/view/results/", params)
      end

      # Full results (in scope, out of scope and errors) for a spider scan.
      # `scan_id` is mandatory in ZAP's API, so it is required here too.
      def full_results(scan_id : Int32) : JSON::Any
        @client.request("/JSON/spider/view/fullResults/", {"scanId" => scan_id.to_s})
      end

      def number_of_results : JSON::Any
        @client.request("/JSON/spider/view/numberOfResults/")
      end

      def excluded_from_scan : JSON::Any
        @client.request("/JSON/spider/view/excludedFromScan/")
      end

      def allowed_resources : JSON::Any
        @client.request("/JSON/spider/view/allowedResources/")
      end

      def option_max_depth : JSON::Any
        @client.request("/JSON/spider/view/optionMaxDepth/")
      end

      def option_max_children : JSON::Any
        @client.request("/JSON/spider/view/optionMaxChildren/")
      end

      def option_max_duration : JSON::Any
        @client.request("/JSON/spider/view/optionMaxDuration/")
      end

      def option_user_agent : JSON::Any
        @client.request("/JSON/spider/view/optionUserAgent/")
      end

      def add_domain_always_in_scope(value : String, is_regex : String = "", is_enabled : String = "") : JSON::Any
        params = {} of String => String
        params["value"] = value
        params["isRegex"] = is_regex unless is_regex.empty?
        params["isEnabled"] = is_enabled unless is_enabled.empty?
        @client.request("/JSON/spider/action/addDomainAlwaysInScope/", params)
      end

      def disable_all_domains_always_in_scope : JSON::Any
        @client.request("/JSON/spider/action/disableAllDomainsAlwaysInScope/")
      end

      def enable_all_domains_always_in_scope : JSON::Any
        @client.request("/JSON/spider/action/enableAllDomainsAlwaysInScope/")
      end

      def modify_domain_always_in_scope(idx : String, value : String = "", is_regex : String = "", is_enabled : String = "") : JSON::Any
        params = {} of String => String
        params["idx"] = idx
        params["value"] = value unless value.empty?
        params["isRegex"] = is_regex unless is_regex.empty?
        params["isEnabled"] = is_enabled unless is_enabled.empty?
        @client.request("/JSON/spider/action/modifyDomainAlwaysInScope/", params)
      end

      def remove_all_scans : JSON::Any
        @client.request("/JSON/spider/action/removeAllScans/")
      end

      def remove_domain_always_in_scope(idx : String) : JSON::Any
        @client.request("/JSON/spider/action/removeDomainAlwaysInScope/", {"idx" => idx})
      end

      def remove_scan(scan_id : String) : JSON::Any
        @client.request("/JSON/spider/action/removeScan/", {"scanId" => scan_id})
      end

      def set_option_accept_cookies(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionAcceptCookies/", {"Boolean" => enabled.to_s})
      end

      def set_option_handle_o_data_parameters_visited(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionHandleODataParametersVisited/", {"Boolean" => enabled.to_s})
      end

      def set_option_handle_parameters(value : String) : JSON::Any
        @client.request("/JSON/spider/action/setOptionHandleParameters/", {"String" => value})
      end

      def set_option_logout_avoidance(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionLogoutAvoidance/", {"Boolean" => enabled.to_s})
      end

      def set_option_max_scans_in_ui(max : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionMaxScansInUI/", {"Integer" => max.to_s})
      end

      def set_option_parse_ds_store(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseDsStore/", {"Boolean" => enabled.to_s})
      end

      def set_option_parse_git(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseGit/", {"Boolean" => enabled.to_s})
      end

      def set_option_parse_svn_entries(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseSVNEntries/", {"Boolean" => enabled.to_s})
      end

      def set_option_parse_sitemap_xml(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionParseSitemapXml/", {"Boolean" => enabled.to_s})
      end

      def set_option_show_advanced_dialog(enabled : Bool) : JSON::Any
        @client.request("/JSON/spider/action/setOptionShowAdvancedDialog/", {"Boolean" => enabled.to_s})
      end

      def set_option_skip_url_string(value : String) : JSON::Any
        @client.request("/JSON/spider/action/setOptionSkipURLString/", {"String" => value})
      end

      def set_option_thread_count(count : Int32) : JSON::Any
        @client.request("/JSON/spider/action/setOptionThreadCount/", {"Integer" => count.to_s})
      end

      def added_nodes(scan_id : String = "") : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id unless scan_id.empty?
        @client.request("/JSON/spider/view/addedNodes/", params)
      end

      def all_urls : JSON::Any
        @client.request("/JSON/spider/view/allUrls/")
      end

      def domains_always_in_scope : JSON::Any
        @client.request("/JSON/spider/view/domainsAlwaysInScope/")
      end

      def option_accept_cookies : JSON::Any
        @client.request("/JSON/spider/view/optionAcceptCookies/")
      end

      def option_domains_always_in_scope : JSON::Any
        @client.request("/JSON/spider/view/optionDomainsAlwaysInScope/")
      end

      def option_domains_always_in_scope_enabled : JSON::Any
        @client.request("/JSON/spider/view/optionDomainsAlwaysInScopeEnabled/")
      end

      def option_handle_o_data_parameters_visited : JSON::Any
        @client.request("/JSON/spider/view/optionHandleODataParametersVisited/")
      end

      def option_handle_parameters : JSON::Any
        @client.request("/JSON/spider/view/optionHandleParameters/")
      end

      def option_logout_avoidance : JSON::Any
        @client.request("/JSON/spider/view/optionLogoutAvoidance/")
      end

      def option_max_parse_size_bytes : JSON::Any
        @client.request("/JSON/spider/view/optionMaxParseSizeBytes/")
      end

      def option_max_scans_in_ui : JSON::Any
        @client.request("/JSON/spider/view/optionMaxScansInUI/")
      end

      def option_parse_comments : JSON::Any
        @client.request("/JSON/spider/view/optionParseComments/")
      end

      def option_parse_ds_store : JSON::Any
        @client.request("/JSON/spider/view/optionParseDsStore/")
      end

      def option_parse_git : JSON::Any
        @client.request("/JSON/spider/view/optionParseGit/")
      end

      def option_parse_robots_txt : JSON::Any
        @client.request("/JSON/spider/view/optionParseRobotsTxt/")
      end

      def option_parse_svn_entries : JSON::Any
        @client.request("/JSON/spider/view/optionParseSVNEntries/")
      end

      def option_parse_sitemap_xml : JSON::Any
        @client.request("/JSON/spider/view/optionParseSitemapXml/")
      end

      def option_post_form : JSON::Any
        @client.request("/JSON/spider/view/optionPostForm/")
      end

      def option_process_form : JSON::Any
        @client.request("/JSON/spider/view/optionProcessForm/")
      end

      def option_send_referer_header : JSON::Any
        @client.request("/JSON/spider/view/optionSendRefererHeader/")
      end

      def option_show_advanced_dialog : JSON::Any
        @client.request("/JSON/spider/view/optionShowAdvancedDialog/")
      end

      def option_skip_url_string : JSON::Any
        @client.request("/JSON/spider/view/optionSkipURLString/")
      end

      def option_thread_count : JSON::Any
        @client.request("/JSON/spider/view/optionThreadCount/")
      end

      def scans : JSON::Any
        @client.request("/JSON/spider/view/scans/")
      end
    end
  end
end
