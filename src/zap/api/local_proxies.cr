module Zap
  module Api
    class LocalProxies
      def initialize(@client : Zap::Client)
      end

      def add_additional_proxy : JSON::Any
        params = {} of String => String
        @client.request("/JSON/localProxies/action/addAdditionalProxy/", params)
      end

      def remove_additional_proxy : JSON::Any
        params = {} of String => String
        @client.request("/JSON/localProxies/action/removeAdditionalProxy/", params)
      end

      def additional_proxies : JSON::Any
        params = {} of String => String
        @client.request("/JSON/localProxies/view/additionalProxies/", params)
      end
    end
  end
end
