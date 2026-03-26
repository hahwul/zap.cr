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

    end
  end
end
