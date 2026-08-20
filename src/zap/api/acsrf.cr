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

      # Generates a form for the request with the given history reference id.
      # ZAP names that parameter `hrefId` and rejects the call without it.
      # `action_url` overrides the action URL of the generated form.
      def gen_form(message_id : Int32, action_url : String = "") : String
        params = {"hrefId" => message_id.to_s}
        params["actionUrl"] = action_url unless action_url.empty?
        @client.request_other("/OTHER/acsrf/other/genForm/", params)
      end
    end
  end
end
