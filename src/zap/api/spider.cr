module Zap
  module Api
    class Spider
      def initialize(@client : Zap::Client)
      end

      # Actions
      def scan(url : String = "", context_name : String = "", subtree_only : Bool = false, in_scope : Bool = false) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["contextName"] = context_name unless context_name.empty?
        params["subtreeOnly"] = subtree_only.to_s
        params["recurse"] = in_scope.to_s
        @client.request("/JSON/spider/action/scan/", params)
      end

      def scan_as_user(context_name : String, user_name : String, url : String = "", subtree_only : Bool = false) : JSON::Any
        params = {"contextName" => context_name, "userName" => user_name}
        params["url"] = url unless url.empty?
        params["subtreeOnly"] = subtree_only.to_s
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

      def results(start : Int32 = -1, count : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request("/JSON/spider/view/results/", params)
      end

      def full_results : JSON::Any
        @client.request("/JSON/spider/view/fullResults/")
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
    end
  end
end
