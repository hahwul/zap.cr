require "json"

module Zap
  module Api
    class Keyboard
      def initialize(@client : Zap::Client)
      end

      def cheatsheet_action_order(inc_unset : String = "") : String
        params = {} of String => String
        params["incUnset"] = inc_unset unless inc_unset.empty?
        @client.request_other("/OTHER/keyboard/other/cheatsheetActionOrder/", params)
      end

      def cheatsheet_key_order(inc_unset : String = "") : String
        params = {} of String => String
        params["incUnset"] = inc_unset unless inc_unset.empty?
        @client.request_other("/OTHER/keyboard/other/cheatsheetKeyOrder/", params)
      end
    end
  end
end
