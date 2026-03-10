module Zap
  module Api
    class Revisit
      def initialize(@client : Zap::Client)
      end

      def revisit_site_off : JSON::Any
        params = {} of String => String
        @client.request("/JSON/revisit/action/revisitSiteOff/", params)
      end

      def revisit_site_on : JSON::Any
        params = {} of String => String
        @client.request("/JSON/revisit/action/revisitSiteOn/", params)
      end

      def revisit_list : JSON::Any
        params = {} of String => String
        @client.request("/JSON/revisit/view/revisitList/", params)
      end
    end
  end
end
