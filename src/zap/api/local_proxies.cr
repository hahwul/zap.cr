module Zap
  module Api
    class LocalProxies
      def initialize(@client : Zap::Client)
      end

      def add_additional_proxy : JSON::Any
        @client.request("/JSON/localProxies/action/addAdditionalProxy/")
      end

      def remove_additional_proxy : JSON::Any
        @client.request("/JSON/localProxies/action/removeAdditionalProxy/")
      end

      def additional_proxies : JSON::Any
        @client.request("/JSON/localProxies/view/additionalProxies/")
      end
    end
  end
end
