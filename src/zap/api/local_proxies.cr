module Zap
  module Api
    # Additional local proxies, beyond the main one ZAP always listens on.
    class LocalProxies
      def initialize(@client : Zap::Client)
      end

      # `address` and `port` identify the proxy and are required; the three
      # behaviour flags are left at ZAP's defaults unless given.
      def add_additional_proxy(
        address : String,
        port : Int32,
        behind_nat : Bool? = nil,
        always_decode_zip : Bool? = nil,
        remove_unsupported_encodings : Bool? = nil,
      ) : JSON::Any
        params = {"address" => address, "port" => port.to_s}
        params["behindNat"] = behind_nat.to_s unless behind_nat.nil?
        params["alwaysDecodeZip"] = always_decode_zip.to_s unless always_decode_zip.nil?
        params["removeUnsupportedEncodings"] = remove_unsupported_encodings.to_s unless remove_unsupported_encodings.nil?
        @client.request("/JSON/localProxies/action/addAdditionalProxy/", params)
      end

      def remove_additional_proxy(address : String, port : Int32) : JSON::Any
        @client.request("/JSON/localProxies/action/removeAdditionalProxy/", {"address" => address, "port" => port.to_s})
      end

      def additional_proxies : JSON::Any
        @client.request("/JSON/localProxies/view/additionalProxies/")
      end
    end
  end
end
