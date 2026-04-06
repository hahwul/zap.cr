module Zap
  module Api
    class CustomPayloads
      def initialize(@client : Zap::Client)
      end

      def add_custom_payload : JSON::Any
        @client.request("/JSON/custompayloads/action/addCustomPayload/")
      end

      def disable_custom_payload : JSON::Any
        @client.request("/JSON/custompayloads/action/disableCustomPayload/")
      end

      def disable_custom_payloads : JSON::Any
        @client.request("/JSON/custompayloads/action/disableCustomPayloads/")
      end

      def enable_custom_payload : JSON::Any
        @client.request("/JSON/custompayloads/action/enableCustomPayload/")
      end

      def enable_custom_payloads : JSON::Any
        @client.request("/JSON/custompayloads/action/enableCustomPayloads/")
      end

      def remove_custom_payload : JSON::Any
        @client.request("/JSON/custompayloads/action/removeCustomPayload/")
      end

      def custom_payloads : JSON::Any
        @client.request("/JSON/custompayloads/view/customPayloads/")
      end

      def custom_payloads_categories : JSON::Any
        @client.request("/JSON/custompayloads/view/customPayloadsCategories/")
      end
    end
  end
end
