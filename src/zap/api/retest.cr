module Zap
  module Api
    class Retest
      def initialize(@client : Zap::Client)
      end

      def retest : JSON::Any
        @client.request("/JSON/retest/action/retest/")
      end
    end
  end
end
