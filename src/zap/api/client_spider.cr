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

      # Stops a running Client Spider scan. Omitting the scan id stops the most
      # recent scan.
      def stop(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/clientSpider/action/stop/", params)
      end

      # Returns the progress (0-100) of a Client Spider scan. Omitting the scan id
      # reports on the most recent scan.
      def status(scan_id : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["scanId"] = scan_id.to_s if scan_id >= 0
        @client.request("/JSON/clientSpider/view/status/", params)
      end
    end
  end
end
