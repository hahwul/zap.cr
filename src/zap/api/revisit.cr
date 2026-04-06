module Zap
  module Api
    class Revisit
      def initialize(@client : Zap::Client)
      end

      def revisit_site_off : JSON::Any
        @client.request("/JSON/revisit/action/revisitSiteOff/")
      end

      def revisit_site_on : JSON::Any
        @client.request("/JSON/revisit/action/revisitSiteOn/")
      end

      def revisit_list : JSON::Any
        @client.request("/JSON/revisit/view/revisitList/")
      end
    end
  end
end
