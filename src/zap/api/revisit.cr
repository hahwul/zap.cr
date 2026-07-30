module Zap
  module Api
    class Revisit
      def initialize(@client : Zap::Client)
      end

      def revisit_site_off(site : String) : JSON::Any
        @client.request("/JSON/revisit/action/revisitSiteOff/", {"site" => site})
      end

      # Replays the recorded traffic for `site` between the two timestamps.
      # ZAP expects `start_time` / `end_time` in its `yyyy-MM-dd HH:mm:ss`
      # form and requires all three parameters.
      def revisit_site_on(site : String, start_time : String, end_time : String) : JSON::Any
        @client.request("/JSON/revisit/action/revisitSiteOn/", {
          "site" => site, "startTime" => start_time, "endTime" => end_time,
        })
      end

      def revisit_list : JSON::Any
        @client.request("/JSON/revisit/view/revisitList/")
      end
    end
  end
end
