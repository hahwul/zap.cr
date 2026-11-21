require "./url_scope"

module Zap
  module Api
    class Exim
      include UrlScope

      def initialize(@client : Zap::Client)
      end

      def import_har(file_path : String, *, max_messages : Int32? = nil) : JSON::Any
        params = {"filePath" => file_path}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/exim/action/importHar/", params)
      end

      # Imports the recorded messages into the ZAP session. Send the archive
      # in the POST body because it can be large and contain sensitive data.
      def import_har_data(data : String, *, max_messages : Int32? = nil) : JSON::Any
        params = {"data" => data, "sendRequests" => "false"}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/exim/action/importHar/", params, post: true)
      end

      def import_mod_security_log(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/importModsec2Logs/", {"filePath" => file_path})
      end

      def import_urls(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/importUrls/", {"filePath" => file_path})
      end

      def import_zap_logs(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/importZapLogs/", {"filePath" => file_path})
      end

      # Exports all captured messages when `base_url` is empty. Otherwise
      # the URL selects a site or directory.
      def export_har(base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        url = base_url.empty? ? "" : directory_url(base_url)
        JSON.parse(request_har(url, start, count))
      rescue ex : JSON::ParseException
        raise Zap::Error.new("Invalid JSON response from /OTHER/exim/other/exportHar/: #{ex.message}")
      end

      # Exports captured messages from a required site or directory URL.
      def export_site_messages_har(url : String, start : Int32 = -1, count : Int32 = -1) : String
        request_har(directory_url(url), start, count)
      end

      private def request_har(url : String, start : Int32, count : Int32) : String
        params = {} of String => String
        params["baseurl"] = url unless url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request_other("/OTHER/exim/other/exportHar/", params)
      end

      def export_sites_tree(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/exportSitesTree/", {"filePath" => file_path})
      end

      def prune_sites_tree(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/pruneSitesTree/", {"filePath" => file_path})
      end

      def export_har_by_id(ids : String) : String
        @client.request_other("/OTHER/exim/other/exportHarById/", {"ids" => ids})
      end

      def send_har_request(request : String, follow_redirects : Bool? = nil) : String
        params = {"request" => request}
        params["followRedirects"] = follow_redirects.to_s unless follow_redirects.nil?
        @client.request_other("/OTHER/exim/other/sendHarRequest/", params)
      end
    end
  end
end
