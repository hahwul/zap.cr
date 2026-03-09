module Zap
  module Api
    class Reveal
      def initialize(@client : Zap::Client)
      end

      def reveal_hidden_fields? : JSON::Any
        @client.request("/JSON/reveal/view/optionRevealHiddenFields/")
      end

      def set_reveal_hidden_fields(enabled : Bool) : JSON::Any
        @client.request("/JSON/reveal/action/setRevealHiddenFields/", {"Boolean" => enabled.to_s})
      end
    end
  end
end
