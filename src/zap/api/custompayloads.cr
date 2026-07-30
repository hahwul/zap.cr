module Zap
  module Api
    # Custom payloads used by scan rules, grouped into categories. Use
    # `#custom_payloads_categories` to discover the category names.
    class CustomPayloads
      def initialize(@client : Zap::Client)
      end

      # Actions
      #
      # `category` is required by ZAP. Omitting `payload` applies the action to
      # the whole category.
      def add_custom_payload(category : String, payload : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/addCustomPayload/", category_params(category, payload))
      end

      def remove_custom_payload(category : String, payload : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/removeCustomPayload/", category_params(category, payload))
      end

      def enable_custom_payload(category : String, payload : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/enableCustomPayload/", category_params(category, payload))
      end

      def disable_custom_payload(category : String, payload : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/disableCustomPayload/", category_params(category, payload))
      end

      # Enables/disables every payload; restricted to one category when given.
      def enable_custom_payloads(category : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/enableCustomPayloads/", optional_category_params(category))
      end

      def disable_custom_payloads(category : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/action/disableCustomPayloads/", optional_category_params(category))
      end

      # Views
      def custom_payloads(category : String = "") : JSON::Any
        @client.request("/JSON/custompayloads/view/customPayloads/", optional_category_params(category))
      end

      def custom_payloads_categories : JSON::Any
        @client.request("/JSON/custompayloads/view/customPayloadsCategories/")
      end

      private def category_params(category : String, payload : String) : Hash(String, String)
        params = {"category" => category}
        params["payload"] = payload unless payload.empty?
        params
      end

      private def optional_category_params(category : String) : Hash(String, String)
        params = {} of String => String
        params["category"] = category unless category.empty?
        params
      end
    end
  end
end
