module Zap
  module Api
    class CustomPayloads
      def initialize(@client : Zap::Client)
      end

      def add_custom_payload : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/addCustomPayload/", params)
      end

      def disable_custom_payload : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/disableCustomPayload/", params)
      end

      def disable_custom_payloads : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/disableCustomPayloads/", params)
      end

      def enable_custom_payload : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/enableCustomPayload/", params)
      end

      def enable_custom_payloads : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/enableCustomPayloads/", params)
      end

      def remove_custom_payload : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/action/removeCustomPayload/", params)
      end

      def custom_payloads : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/view/customPayloads/", params)
      end

      def custom_payloads_categories : JSON::Any
        params = {} of String => String
        @client.request("/JSON/custompayloads/view/customPayloadsCategories/", params)
      end
    end
  end
end
