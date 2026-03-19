module Zap
  module Api
    class ForcedUser
      def initialize(@client : Zap::Client)
      end

      def get(context_id : Int32) : JSON::Any
        @client.request("/JSON/forcedUser/view/getForcedUser/", {"contextId" => context_id.to_s})
      end

      def enabled?(context_id : Int32) : JSON::Any
        @client.request("/JSON/forcedUser/view/isForcedUserModeEnabled/", {"contextId" => context_id.to_s})
      end

      def set(context_id : Int32, user_id : Int32) : JSON::Any
        @client.request("/JSON/forcedUser/action/setForcedUser/", {"contextId" => context_id.to_s, "userId" => user_id.to_s})
      end

      def set_enabled(context_id : Int32, enabled : Bool) : JSON::Any
        @client.request("/JSON/forcedUser/action/setForcedUserModeEnabled/", {"contextId" => context_id.to_s, "boolean" => enabled.to_s})
      end

      def get_forced_user(context_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        @client.request("/JSON/forcedUser/view/getForcedUser/", params)
      end

      def is_forced_user_mode_enabled : JSON::Any
        params = {} of String => String
        @client.request("/JSON/forcedUser/view/isForcedUserModeEnabled/", params)
      end

      def set_forced_user(context_id : String, user_id : String) : JSON::Any
        params = {} of String => String
        params["contextId"] = context_id
        params["userId"] = user_id
        @client.request("/JSON/forcedUser/action/setForcedUser/", params)
      end

      def set_forced_user_mode_enabled(boolean : String) : JSON::Any
        params = {} of String => String
        params["boolean"] = boolean
        @client.request("/JSON/forcedUser/action/setForcedUserModeEnabled/", params)
      end
    end
  end
end
