module Zap
  module Api
    class Users
      def initialize(@client : Zap::Client)
      end

      # Views
      def list(context_id : Int32) : JSON::Any
        @client.request("/JSON/users/view/usersList/", {"contextId" => context_id.to_s})
      end

      def get(context_id : Int32, user_id : Int32) : JSON::Any
        @client.request("/JSON/users/view/getUserById/", {"contextId" => context_id.to_s, "userId" => user_id.to_s})
      end

      def get_auth_credentials_config_params(context_id : Int32) : JSON::Any
        @client.request("/JSON/users/view/getAuthenticationCredentialsConfigParams/", {"contextId" => context_id.to_s})
      end

      def get_auth_credentials(context_id : Int32, user_id : Int32) : JSON::Any
        @client.request("/JSON/users/view/getAuthenticationCredentials/", {"contextId" => context_id.to_s, "userId" => user_id.to_s})
      end

      # Actions
      def new_user(context_id : Int32, name : String) : JSON::Any
        @client.request("/JSON/users/action/newUser/", {"contextId" => context_id.to_s, "name" => name})
      end

      def remove_user(context_id : Int32, user_id : Int32) : JSON::Any
        @client.request("/JSON/users/action/removeUser/", {"contextId" => context_id.to_s, "userId" => user_id.to_s})
      end

      def set_enabled(context_id : Int32, user_id : Int32, enabled : Bool) : JSON::Any
        @client.request("/JSON/users/action/setUserEnabled/", {"contextId" => context_id.to_s, "userId" => user_id.to_s, "enabled" => enabled.to_s})
      end

      def set_name(context_id : Int32, user_id : Int32, name : String) : JSON::Any
        @client.request("/JSON/users/action/setUserName/", {"contextId" => context_id.to_s, "userId" => user_id.to_s, "name" => name})
      end

      def set_auth_credentials(context_id : Int32, user_id : Int32, config_params : String = "") : JSON::Any
        params = {"contextId" => context_id.to_s, "userId" => user_id.to_s}
        params["authCredentialsConfigParams"] = config_params unless config_params.empty?
        @client.request("/JSON/users/action/setAuthenticationCredentials/", params)
      end

      def authenticate_as_user(context_id : String, user_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        @client.request("/JSON/users/action/authenticateAsUser/", params)
      end

      def poll_as_user(context_id : String, user_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        @client.request("/JSON/users/action/pollAsUser/", params)
      end

      def set_authentication_state(context_id : String, user_id : String, last_poll_result : String = "", last_poll_time_in_ms : String = "", requests_since_last_poll : String = "") : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        params["lastPollResult"] = last_poll_result unless last_poll_result.empty?
        params["lastPollTimeInMs"] = last_poll_time_in_ms unless last_poll_time_in_ms.empty?
        params["requestsSinceLastPoll"] = requests_since_last_poll unless requests_since_last_poll.empty?
        @client.request("/JSON/users/action/setAuthenticationState/", params)
      end

      def set_cookie(context_id : String, user_id : String, domain : String, name : String, value : String, path : String = "", secure : String = "") : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        params["domain"] = domain
        params["name"] = name
        params["value"] = value
        params["path"] = path unless path.empty?
        params["secure"] = secure unless secure.empty?
        @client.request("/JSON/users/action/setCookie/", params)
      end

      def get_authentication_session(context_id : String, user_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        @client.request("/JSON/users/view/getAuthenticationSession/", params)
      end

      def get_authentication_state(context_id : String, user_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        @client.request("/JSON/users/view/getAuthenticationState/", params)
      end
    end
  end
end
