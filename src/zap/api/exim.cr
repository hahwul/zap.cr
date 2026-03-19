module Zap
  module Api
    class Exim
      def initialize(@client : Zap::Client)
      end

      def import_har(file_path : String) : JSON::Any
        @client.request("/JSON/exim/action/importHar/", {"filePath" => file_path})
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

      def export_har(base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        params = {} of String => String
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request("/JSON/exim/action/exportHar/", params)
      end

      def export_site_messages_har(url : String) : String
        @client.request_other("/OTHER/exim/other/exportHar/", {"url" => url})
      end

      def export_sites_tree(file_path : String) : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path
        @client.request("/JSON/exim/action/exportSitesTree/", params)
      end

      def prune_sites_tree(file_path : String) : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path
        @client.request("/JSON/exim/action/pruneSitesTree/", params)
      end

      def export_har_by_id(ids : String) : String
        params = {} of String => String
        params["ids"] = ids
        @client.request_other("/OTHER/exim/other/exportHarById/", params)
      end

      def send_har_request(request : String, follow_redirects : String = "") : String
        params = {} of String => String
        params["request"] = request
        params["followRedirects"] = follow_redirects unless follow_redirects.empty?
        @client.request_other("/OTHER/exim/other/sendHarRequest/", params)
      end

      def import_modsec2_logs(file_path : String) : JSON::Any
        params = {} of String => String
        params["filePath"] = file_path
        @client.request("/JSON/exim/action/importModsec2Logs/", params)
      end
    end
  end
end
