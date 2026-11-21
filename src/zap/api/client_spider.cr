module Zap
  module Api
    # Client Spider is the modern, browser-based crawler introduced in ZAP 2.16
    # (the "client" add-on). It supersedes the AJAX Spider for many use cases by
    # driving real browsers and crawling client-side rendered applications.
    class ClientSpider
      def initialize(@client : Zap::Client)
      end

      # Starts a Client Spider scan and returns the scan id. All parameters are
      # optional on the ZAP side; only the ones supplied here are sent.
      def scan(
        url : String = "",
        browser : String = "",
        context_name : String = "",
        user_name : String = "",
        subtree_only : Bool? = nil,
        max_crawl_depth : Int32 = -1,
        page_load_time : Int32 = -1,
        action_wait_time : Int32 = -1,
        number_of_browsers : Int32 = -1,
        scope_check : String = "",
        logout_avoidance : Bool? = nil,
      ) : JSON::Any
        params = {} of String => String
        params["url"] = url unless url.empty?
        params["browser"] = browser unless browser.empty?
        params["contextName"] = context_name unless context_name.empty?
        params["userName"] = user_name unless user_name.empty?
        params["subtreeOnly"] = subtree_only.to_s unless subtree_only.nil?
        params["maxCrawlDepth"] = max_crawl_depth.to_s if max_crawl_depth >= 0
        params["pageLoadTime"] = page_load_time.to_s if page_load_time >= 0
        params["actionWaitTime"] = action_wait_time.to_s if action_wait_time >= 0
        params["numberOfBrowsers"] = number_of_browsers.to_s if number_of_browsers >= 0
        params["scopeCheck"] = scope_check unless scope_check.empty?
        params["logoutAvoidance"] = logout_avoidance.to_s unless logout_avoidance.nil?
        @client.request("/JSON/clientSpider/action/scan/", params)
      end

      # Stops a running Client Spider scan identified by its scan ID.
      def stop(scan_id : Int32 = -1) : JSON::Any
        raise Zap::Error.new("Client Spider stop requires a nonnegative scan ID") if scan_id < 0
        @client.request("/JSON/clientSpider/action/stop/", {"scanId" => scan_id.to_s})
      end

      # Returns the progress (0-100) of the specified Client Spider scan.
      def status(scan_id : Int32 = -1) : JSON::Any
        raise Zap::Error.new("Client Spider status requires a nonnegative scan ID") if scan_id < 0
        @client.request("/JSON/clientSpider/view/status/", {"scanId" => scan_id.to_s})
      end

      # Default options for the Client Spider add-on.
      def option_action_wait_time_in_secs : JSON::Any
        @client.request("/JSON/clientSpider/view/optionActionWaitTimeInSecs/")
      end

      def option_browser_id : JSON::Any
        @client.request("/JSON/clientSpider/view/optionBrowserId/")
      end

      def option_initial_load_time_in_secs : JSON::Any
        @client.request("/JSON/clientSpider/view/optionInitialLoadTimeInSecs/")
      end

      def option_logout_avoidance : JSON::Any
        @client.request("/JSON/clientSpider/view/optionLogoutAvoidance/")
      end

      def option_max_children : JSON::Any
        @client.request("/JSON/clientSpider/view/optionMaxChildren/")
      end

      def option_max_depth : JSON::Any
        @client.request("/JSON/clientSpider/view/optionMaxDepth/")
      end

      def option_max_duration : JSON::Any
        @client.request("/JSON/clientSpider/view/optionMaxDuration/")
      end

      def option_max_scans_in_ui : JSON::Any
        @client.request("/JSON/clientSpider/view/optionMaxScansInUi/")
      end

      def option_page_load_time_in_secs : JSON::Any
        @client.request("/JSON/clientSpider/view/optionPageLoadTimeInSecs/")
      end

      def option_scope_check : JSON::Any
        @client.request("/JSON/clientSpider/view/optionScopeCheck/")
      end

      def option_shutdown_time_in_secs : JSON::Any
        @client.request("/JSON/clientSpider/view/optionShutdownTimeInSecs/")
      end

      def option_thread_count : JSON::Any
        @client.request("/JSON/clientSpider/view/optionThreadCount/")
      end

      def set_option_action_wait_time_in_secs(seconds : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionActionWaitTimeInSecs/", {"Integer" => seconds.to_s})
      end

      def set_option_browser_id(browser : String) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionBrowserId/", {"String" => browser})
      end

      def set_option_initial_load_time_in_secs(seconds : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionInitialLoadTimeInSecs/", {"Integer" => seconds.to_s})
      end

      def set_option_logout_avoidance(enabled : Bool) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionLogoutAvoidance/", {"Boolean" => enabled.to_s})
      end

      def set_option_max_children(max : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionMaxChildren/", {"Integer" => max.to_s})
      end

      def set_option_max_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionMaxDepth/", {"Integer" => depth.to_s})
      end

      def set_option_max_duration(minutes : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionMaxDuration/", {"Integer" => minutes.to_s})
      end

      def set_option_max_scans_in_ui(max : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionMaxScansInUi/", {"Integer" => max.to_s})
      end

      def set_option_page_load_time_in_secs(seconds : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionPageLoadTimeInSecs/", {"Integer" => seconds.to_s})
      end

      def set_option_scope_check(value : String) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionScopeCheck/", {"String" => value})
      end

      def set_option_shutdown_time_in_secs(seconds : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionShutdownTimeInSecs/", {"Integer" => seconds.to_s})
      end

      def set_option_thread_count(count : Int32) : JSON::Any
        @client.request("/JSON/clientSpider/action/setOptionThreadCount/", {"Integer" => count.to_s})
      end
    end
  end
end
