module Zap
  module Api
    class HttpSessions
      def initialize(@client : Zap::Client)
      end

      # Views
      def sessions(site : String, session_name : String = "") : JSON::Any
        params = {"site" => site}
        params["session"] = session_name unless session_name.empty?
        @client.request("/JSON/httpSessions/view/sessions/", params)
      end

      def active_session(site : String) : JSON::Any
        @client.request("/JSON/httpSessions/view/activeSession/", {"site" => site})
      end

      def session_tokens(site : String) : JSON::Any
        @client.request("/JSON/httpSessions/view/sessionTokens/", {"site" => site})
      end

      # Actions
      def create_empty_session(site : String, session_name : String = "") : JSON::Any
        params = {"site" => site}
        params["session"] = session_name unless session_name.empty?
        @client.request("/JSON/httpSessions/action/createEmptySession/", params)
      end

      def remove_session(site : String, session_name : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/removeSession/", {"site" => site, "session" => session_name})
      end

      def set_active_session(site : String, session_name : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/setActiveSession/", {"site" => site, "session" => session_name})
      end

      def unset_active_session(site : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/unsetActiveSession/", {"site" => site})
      end

      def add_session_token(site : String, token_name : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/addSessionToken/", {"site" => site, "sessionToken" => token_name})
      end

      def remove_session_token(site : String, token_name : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/removeSessionToken/", {"site" => site, "sessionToken" => token_name})
      end

      def set_session_token_value(site : String, session_name : String, token_name : String, token_value : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/setSessionTokenValue/", {
          "site" => site, "session" => session_name, "sessionToken" => token_name, "tokenValue" => token_value,
        })
      end

      def rename_session(site : String, old_name : String, new_name : String) : JSON::Any
        @client.request("/JSON/httpSessions/action/renameSession/", {"site" => site, "oldSessionName" => old_name, "newSessionName" => new_name})
      end

      def add_default_session_token(session_token : String, token_enabled : String = "") : JSON::Any
        params = {} of String => String
        params["sessionToken"] = session_token
        params["tokenEnabled"] = token_enabled unless token_enabled.empty?
        @client.request("/JSON/httpSessions/action/addDefaultSessionToken/", params)
      end

      def remove_default_session_token(session_token : String) : JSON::Any
        params = {} of String => String
        params["sessionToken"] = session_token
        @client.request("/JSON/httpSessions/action/removeDefaultSessionToken/", params)
      end

      def set_default_session_token_enabled(session_token : String, token_enabled : String) : JSON::Any
        params = {} of String => String
        params["sessionToken"] = session_token
        params["tokenEnabled"] = token_enabled
        @client.request("/JSON/httpSessions/action/setDefaultSessionTokenEnabled/", params)
      end

      def default_session_tokens : JSON::Any
        @client.request("/JSON/httpSessions/view/defaultSessionTokens/")
      end

      def sites : JSON::Any
        @client.request("/JSON/httpSessions/view/sites/")
      end
    end
  end
end
