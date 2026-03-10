module Zap
  module Api
    class Wappalyzer
      def initialize(@client : Zap::Client)
      end

      def list_all : JSON::Any
        params = {} of String => String
        @client.request("/JSON/wappalyzer/view/listAll/", params)
      end

      def list_site : JSON::Any
        params = {} of String => String
        @client.request("/JSON/wappalyzer/view/listSite/", params)
      end

      def list_sites : JSON::Any
        params = {} of String => String
        @client.request("/JSON/wappalyzer/view/listSites/", params)
      end
    end
  end
end
