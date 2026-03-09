module Zap
  module Api
    class Params
      def initialize(@client : Zap::Client)
      end

      def params(site : String = "") : JSON::Any
        p = {} of String => String
        p["site"] = site unless site.empty?
        @client.request("/JSON/params/view/params/", p)
      end
    end
  end
end
