require "json"

module Zap
  module Api
    class Quickstartlaunch
      def initialize(@client : Zap::Client)
      end

      def start_page : String
        @client.request_other("/OTHER/quickstartlaunch/other/startPage/")
      end
    end
  end
end
