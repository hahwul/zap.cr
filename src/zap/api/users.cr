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
    end
  end
end
