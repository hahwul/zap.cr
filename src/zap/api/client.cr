module Zap
  module Api
    class Client
      def initialize(@client : Zap::Client)
      end

      def export_client_map : JSON::Any
        params = {} of String => String
        @client.request("/JSON/client/action/exportClientMap/", params)
      end

      def report_event : JSON::Any
        params = {} of String => String
        @client.request("/JSON/client/action/reportEvent/", params)
      end

      def report_object : JSON::Any
        params = {} of String => String
        @client.request("/JSON/client/action/reportObject/", params)
      end

      def report_zest_script : JSON::Any
        params = {} of String => String
        @client.request("/JSON/client/action/reportZestScript/", params)
      end

      def report_zest_statement : JSON::Any
        params = {} of String => String
        @client.request("/JSON/client/action/reportZestStatement/", params)
      end
    end
  end
end
