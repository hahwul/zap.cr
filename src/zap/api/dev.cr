require "json"

module Zap
  module Api
    class Dev
      def initialize(@client : Zap::Client)
      end

      def openapi : String
        @client.request_other("/OTHER/dev/other/openapi/")
      end
    end
  end
end
