module Zap
  module Api
    class Wappalyzer
      def initialize(@client : Zap::Client)
      end

      def list_all : JSON::Any
        @client.request("/JSON/wappalyzer/view/listAll/")
      end

      def list_site : JSON::Any
        @client.request("/JSON/wappalyzer/view/listSite/")
      end

      def list_sites : JSON::Any
        @client.request("/JSON/wappalyzer/view/listSites/")
      end
    end
  end
end
