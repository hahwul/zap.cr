module Zap
  module Api
    class Stats
      def initialize(@client : Zap::Client)
      end

      def stats(key_prefix : String = "") : JSON::Any
        params = {} of String => String
        params["keyPrefix"] = key_prefix unless key_prefix.empty?
        @client.request("/JSON/stats/view/stats/", params)
      end

      def all_sites_stats(key_prefix : String = "") : JSON::Any
        params = {} of String => String
        params["keyPrefix"] = key_prefix unless key_prefix.empty?
        @client.request("/JSON/stats/view/allSitesStats/", params)
      end

      def site_stats(site : String, key_prefix : String = "") : JSON::Any
        params = {"site" => site}
        params["keyPrefix"] = key_prefix unless key_prefix.empty?
        @client.request("/JSON/stats/view/siteStats/", params)
      end

      def clear_stats(key_prefix : String = "") : JSON::Any
        params = {} of String => String
        params["keyPrefix"] = key_prefix unless key_prefix.empty?
        @client.request("/JSON/stats/action/clearStats/", params)
      end

      def set_option_statsd_host(host : String) : JSON::Any
        @client.request("/JSON/stats/action/setOptionStatsdHost/", {"String" => host})
      end

      def set_option_statsd_port(port : Int32) : JSON::Any
        @client.request("/JSON/stats/action/setOptionStatsdPort/", {"Integer" => port.to_s})
      end

      def set_option_statsd_prefix(prefix : String) : JSON::Any
        @client.request("/JSON/stats/action/setOptionStatsdPrefix/", {"String" => prefix})
      end

      def set_option_in_memory_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/stats/action/setOptionInMemoryEnabled/", {"Boolean" => enabled.to_s})
      end

      def set_option_statsd_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/stats/action/setOptionStatsdEnabled/", {"Boolean" => enabled.to_s})
      end

      def option_in_memory_enabled : JSON::Any
        @client.request("/JSON/stats/view/optionInMemoryEnabled/")
      end

      def option_statsd_enabled : JSON::Any
        @client.request("/JSON/stats/view/optionStatsdEnabled/")
      end

      def option_statsd_host : JSON::Any
        @client.request("/JSON/stats/view/optionStatsdHost/")
      end

      def option_statsd_port : JSON::Any
        @client.request("/JSON/stats/view/optionStatsdPort/")
      end

      def option_statsd_prefix : JSON::Any
        @client.request("/JSON/stats/view/optionStatsdPrefix/")
      end
    end
  end
end
