module Zap
  module Api
    # Out-of-band Application Security Testing (OAST) services: BOAST,
    # Interactsh and ZAP's built-in callback server.
    class Oast
      def initialize(@client : Zap::Client)
      end

      # Actions
      #
      # `name` is the OAST service active scan rules should use — one of the
      # names returned by `#get_services`.
      def set_active_scan_service(name : String) : JSON::Any
        @client.request("/JSON/oast/action/setActiveScanService/", {"name" => name})
      end

      def set_boast_options(server : String, poll_in_secs : Int32) : JSON::Any
        @client.request("/JSON/oast/action/setBoastOptions/", {"server" => server, "pollInSecs" => poll_in_secs.to_s})
      end

      def set_callback_options(local_address : String, remote_address : String, port : Int32) : JSON::Any
        @client.request("/JSON/oast/action/setCallbackOptions/", {
          "localAddress" => local_address, "remoteAddress" => remote_address, "port" => port.to_s,
        })
      end

      def set_days_to_keep_records(days : Int32) : JSON::Any
        @client.request("/JSON/oast/action/setDaysToKeepRecords/", {"days" => days.to_s})
      end

      def set_interactsh_options(server : String, poll_in_secs : Int32, auth_token : String = "") : JSON::Any
        @client.request("/JSON/oast/action/setInteractshOptions/", {
          "server" => server, "pollInSecs" => poll_in_secs.to_s, "authToken" => auth_token,
        })
      end

      # Views
      def get_active_scan_service : JSON::Any
        @client.request("/JSON/oast/view/getActiveScanService/")
      end

      def get_boast_options : JSON::Any
        @client.request("/JSON/oast/view/getBoastOptions/")
      end

      def get_callback_options : JSON::Any
        @client.request("/JSON/oast/view/getCallbackOptions/")
      end

      def get_days_to_keep_records : JSON::Any
        @client.request("/JSON/oast/view/getDaysToKeepRecords/")
      end

      def get_interactsh_options : JSON::Any
        @client.request("/JSON/oast/view/getInteractshOptions/")
      end

      def get_services : JSON::Any
        @client.request("/JSON/oast/view/getServices/")
      end
    end
  end
end
