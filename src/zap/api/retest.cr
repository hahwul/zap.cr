module Zap
  module Api
    class Retest
      def initialize(@client : Zap::Client)
      end

      def retest : JSON::Any
        params = {} of String => String
        @client.request("/JSON/retest/action/retest/", params)
      end
    end
  end
end
