module Zap
  module Api
    class Network
      def initialize(@client : Zap::Client)
      end

      # Views
      def aliases : JSON::Any
        @client.request("/JSON/network/view/getAliases/")
      end

      def local_servers : JSON::Any
        @client.request("/JSON/network/view/getLocalServers/")
      end

      def rate_limit_rules : JSON::Any
        @client.request("/JSON/network/view/getRateLimitRules/")
      end

      def connection_timeout : JSON::Any
        @client.request("/JSON/network/view/getConnectionTimeout/")
      end

      def default_user_agent : JSON::Any
        @client.request("/JSON/network/view/getDefaultUserAgent/")
      end

      def dns_ttl_successful_queries : JSON::Any
        @client.request("/JSON/network/view/getDnsTtlSuccessfulQueries/")
      end

      def http_proxy : JSON::Any
        @client.request("/JSON/network/view/getHttpProxy/")
      end

      def http_proxy_exclusions : JSON::Any
        @client.request("/JSON/network/view/getHttpProxyExclusions/")
      end

      def pass_throughs : JSON::Any
        @client.request("/JSON/network/view/getPassThroughs/")
      end

      def socks_proxy : JSON::Any
        @client.request("/JSON/network/view/getSocksProxy/")
      end

      # Actions
      def add_alias(name : String, enabled : Bool = true) : JSON::Any
        @client.request("/JSON/network/action/addAlias/", {"name" => name, "enabled" => enabled.to_s})
      end

      def remove_alias(name : String) : JSON::Any
        @client.request("/JSON/network/action/removeAlias/", {"name" => name})
      end

      def set_alias_enabled(name : String, enabled : Bool) : JSON::Any
        @client.request("/JSON/network/action/setAliasEnabled/", {"name" => name, "enabled" => enabled.to_s})
      end

      def add_local_server(address : String, port : Int32, api : Bool = false, proxy : Bool = true, behind_nat : Bool = false, decode_response : Bool = true, remove_accept_encoding : Bool = true) : JSON::Any
        @client.request("/JSON/network/action/addLocalServer/", {
          "address" => address, "port" => port.to_s, "api" => api.to_s, "proxy" => proxy.to_s,
          "behindNat" => behind_nat.to_s, "decodeResponse" => decode_response.to_s,
          "removeAcceptEncoding" => remove_accept_encoding.to_s,
        })
      end

      def remove_local_server(address : String, port : Int32) : JSON::Any
        @client.request("/JSON/network/action/removeLocalServer/", {"address" => address, "port" => port.to_s})
      end

      def add_pass_through(authority : String, enabled : Bool = true) : JSON::Any
        @client.request("/JSON/network/action/addPassThrough/", {"authority" => authority, "enabled" => enabled.to_s})
      end

      def remove_pass_through(authority : String) : JSON::Any
        @client.request("/JSON/network/action/removePassThrough/", {"authority" => authority})
      end

      def set_connection_timeout(timeout : Int32) : JSON::Any
        @client.request("/JSON/network/action/setConnectionTimeout/", {"timeout" => timeout.to_s})
      end

      def set_default_user_agent(user_agent : String) : JSON::Any
        @client.request("/JSON/network/action/setDefaultUserAgent/", {"userAgent" => user_agent})
      end

      def set_dns_ttl_successful_queries(ttl : Int32) : JSON::Any
        @client.request("/JSON/network/action/setDnsTtlSuccessfulQueries/", {"ttl" => ttl.to_s})
      end

      def add_http_proxy_exclusion(host : String, enabled : Bool = true) : JSON::Any
        @client.request("/JSON/network/action/addHttpProxyExclusion/", {"host" => host, "enabled" => enabled.to_s})
      end

      def remove_http_proxy_exclusion(host : String) : JSON::Any
        @client.request("/JSON/network/action/removeHttpProxyExclusion/", {"host" => host})
      end

      def set_http_proxy(host : String, port : Int32, realm : String = "", username : String = "", password : String = "") : JSON::Any
        params = {"host" => host, "port" => port.to_s}
        params["realm"] = realm unless realm.empty?
        params["username"] = username unless username.empty?
        params["password"] = password unless password.empty?
        @client.request("/JSON/network/action/setHttpProxy/", params)
      end

      def set_http_proxy_auth_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/network/action/setHttpProxyAuthEnabled/", {"enabled" => enabled.to_s})
      end

      def set_http_proxy_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/network/action/setHttpProxyEnabled/", {"enabled" => enabled.to_s})
      end

      def set_socks_proxy(host : String, port : Int32, version : Int32 = 5, use_dns : Bool = true, username : String = "", password : String = "") : JSON::Any
        params = {"host" => host, "port" => port.to_s, "version" => version.to_s, "useDns" => use_dns.to_s}
        params["username"] = username unless username.empty?
        params["password"] = password unless password.empty?
        @client.request("/JSON/network/action/setSocksProxy/", params)
      end

      def set_socks_proxy_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/network/action/setSocksProxyEnabled/", {"enabled" => enabled.to_s})
      end

      def generate_root_ca_cert : JSON::Any
        @client.request("/JSON/network/action/generateRootCaCert/")
      end

      def import_root_ca_cert(file_path : String) : JSON::Any
        @client.request("/JSON/network/action/importRootCaCert/", {"filePath" => file_path})
      end

      def set_root_ca_cert_validity(validity : Int32) : JSON::Any
        @client.request("/JSON/network/action/setRootCaCertValidity/", {"validity" => validity.to_s})
      end

      def set_server_cert_validity(validity : Int32) : JSON::Any
        @client.request("/JSON/network/action/setServerCertValidity/", {"validity" => validity.to_s})
      end
    end
  end
end
