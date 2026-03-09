module Zap
  module Api
    class Acsrf
      def initialize(@client : Zap::Client)
      end

      def option_tokens_names : JSON::Any
        @client.request("/JSON/acsrf/view/optionTokensNames/")
      end

      def option_partial_matching_enabled : JSON::Any
        @client.request("/JSON/acsrf/view/optionPartialMatchingEnabled/")
      end

      def add_option_token(name : String) : JSON::Any
        @client.request("/JSON/acsrf/action/addOptionToken/", {"String" => name})
      end

      def remove_option_token(name : String) : JSON::Any
        @client.request("/JSON/acsrf/action/removeOptionToken/", {"String" => name})
      end

      def set_option_partial_matching_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/acsrf/action/setOptionPartialMatchingEnabled/", {"Boolean" => enabled.to_s})
      end

      def gen_form(message_id : Int32) : String
        @client.request_other("/OTHER/acsrf/other/genForm/", {"hid" => message_id.to_s})
      end
    end
  end
end
