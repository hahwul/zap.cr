module Zap
  module Api
    class Reveal
      def initialize(@client : Zap::Client)
      end

      # ZAP names this view `reveal` and its action `setReveal` — there is no
      # `optionRevealHiddenFields` / `setRevealHiddenFields`. Both names are
      # kept and delegate, so they reach an endpoint that exists instead of
      # failing with `bad_view` / `bad_action`.
      def reveal_hidden_fields? : JSON::Any
        reveal
      end

      def set_reveal_hidden_fields(enabled : Bool) : JSON::Any
        set_reveal(enabled.to_s)
      end

      def set_reveal(reveal : String) : JSON::Any
        params = {} of String => String
        params["reveal"] = reveal
        @client.request("/JSON/reveal/action/setReveal/", params)
      end

      def reveal : JSON::Any
        @client.request("/JSON/reveal/view/reveal/")
      end
    end
  end
end
