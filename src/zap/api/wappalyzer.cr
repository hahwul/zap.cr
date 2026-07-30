module Zap
  module Api
    class Wappalyzer
      def initialize(@client : Zap::Client)
      end

      def list_all : JSON::Any
        @client.request("/JSON/wappalyzer/view/listAll/")
      end

      # The technologies detected for one site. Use `#list_sites` to discover
      # the site names ZAP recognises.
      def list_site(site : String) : JSON::Any
        @client.request("/JSON/wappalyzer/view/listSite/", {"site" => site})
      end

      def list_sites : JSON::Any
        @client.request("/JSON/wappalyzer/view/listSites/")
      end
    end
  end
end
