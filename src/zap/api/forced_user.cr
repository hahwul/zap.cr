module Zap
  module Api
    class ForcedUser
      def initialize(@client : Zap::Client)
      end

      def get(context_id : Int32) : JSON::Any
        @client.request("/JSON/forcedUser/view/getForcedUser/", {"contextId" => context_id.to_s})
      end

      # "Forced user" mode is a global toggle in ZAP, not a per-context one:
      # the forced *user* is configured per context (see `#set`), but turning
      # the mode on or off applies to the whole session.
      def enabled? : JSON::Any
        @client.request("/JSON/forcedUser/view/isForcedUserModeEnabled/")
      end

      def set(context_id : Int32, user_id : Int32) : JSON::Any
        @client.request("/JSON/forcedUser/action/setForcedUser/", {"contextId" => context_id.to_s, "userId" => user_id.to_s})
      end

      def set_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/forcedUser/action/setForcedUserModeEnabled/", {"boolean" => enabled.to_s})
      end
    end
  end
end
