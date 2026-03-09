module Zap
  module Api
    class AccessControl
      def initialize(@client : Zap::Client)
      end

      def scan_status(context_id : Int32) : JSON::Any
        @client.request("/JSON/accessControl/view/getScanStatus/", {"contextId" => context_id.to_s})
      end

      def scan_progress(context_id : Int32) : JSON::Any
        @client.request("/JSON/accessControl/view/getScanProgress/", {"contextId" => context_id.to_s})
      end

      def scan(context_id : Int32) : JSON::Any
        @client.request("/JSON/accessControl/action/scan/", {"contextId" => context_id.to_s})
      end

      def write_html_report(context_id : Int32, file_name : String) : JSON::Any
        @client.request("/JSON/accessControl/action/writeHTMLreport/", {"contextId" => context_id.to_s, "fileName" => file_name})
      end
    end
  end
end
