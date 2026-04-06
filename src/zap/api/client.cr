module Zap
  module Api
    class Client
      def initialize(@client : Zap::Client)
      end

      def export_client_map : JSON::Any
        @client.request("/JSON/client/action/exportClientMap/")
      end

      def report_event : JSON::Any
        @client.request("/JSON/client/action/reportEvent/")
      end

      def report_object : JSON::Any
        @client.request("/JSON/client/action/reportObject/")
      end

      def report_zest_script : JSON::Any
        @client.request("/JSON/client/action/reportZestScript/")
      end

      def report_zest_statement : JSON::Any
        @client.request("/JSON/client/action/reportZestStatement/")
      end
    end
  end
end
