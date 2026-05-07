module Zap
  module Api
    class Context
      def initialize(@client : Zap::Client)
      end

      # Views
      def context(name : String) : JSON::Any
        @client.request("/JSON/context/view/context/", {"contextName" => name})
      end

      def context_list : JSON::Any
        @client.request("/JSON/context/view/contextList/")
      end

      def excluded_regexs(name : String) : JSON::Any
        @client.request("/JSON/context/view/excludeRegexs/", {"contextName" => name})
      end

      def included_regexs(name : String) : JSON::Any
        @client.request("/JSON/context/view/includeRegexs/", {"contextName" => name})
      end

      def urls(name : String) : JSON::Any
        @client.request("/JSON/context/view/urls/", {"contextName" => name})
      end

      def technology_list : JSON::Any
        @client.request("/JSON/context/view/technologyList/")
      end

      def included_technology_list(name : String) : JSON::Any
        @client.request("/JSON/context/view/includedTechnologyList/", {"contextName" => name})
      end

      def excluded_technology_list(name : String) : JSON::Any
        @client.request("/JSON/context/view/excludedTechnologyList/", {"contextName" => name})
      end

      # Actions
      def new_context(name : String) : JSON::Any
        @client.request("/JSON/context/action/newContext/", {"contextName" => name})
      end

      def remove_context(name : String) : JSON::Any
        @client.request("/JSON/context/action/removeContext/", {"contextName" => name})
      end

      def export_context(name : String, file_path : String) : JSON::Any
        @client.request("/JSON/context/action/exportContext/", {"contextName" => name, "contextFile" => file_path})
      end

      def import_context(file_path : String) : JSON::Any
        @client.request("/JSON/context/action/importContext/", {"contextFile" => file_path})
      end

      def include_in_context(name : String, regex : String) : JSON::Any
        @client.request("/JSON/context/action/includeInContext/", {"contextName" => name, "regex" => regex})
      end

      def exclude_from_context(name : String, regex : String) : JSON::Any
        @client.request("/JSON/context/action/excludeFromContext/", {"contextName" => name, "regex" => regex})
      end

      def include_all_context_technologies(name : String = "") : JSON::Any
        params = {} of String => String
        params["contextName"] = name unless name.empty?
        @client.request("/JSON/context/action/includeAllContextTechnologies/", params)
      end

      def exclude_all_context_technologies(name : String = "") : JSON::Any
        params = {} of String => String
        params["contextName"] = name unless name.empty?
        @client.request("/JSON/context/action/excludeAllContextTechnologies/", params)
      end

      def include_context_technologies(name : String, tech : String) : JSON::Any
        @client.request("/JSON/context/action/includeContextTechnologies/", {"contextName" => name, "technologyNames" => tech})
      end

      def exclude_context_technologies(name : String, tech : String) : JSON::Any
        @client.request("/JSON/context/action/excludeContextTechnologies/", {"contextName" => name, "technologyNames" => tech})
      end

      def set_context_in_scope(name : String, in_scope : Bool) : JSON::Any
        @client.request("/JSON/context/action/setContextInScope/", {"contextName" => name, "booleanInScope" => in_scope.to_s})
      end

      def set_context_checking_strategy(context_name : String, checking_strategy : String, poll_url : String = "", poll_data : String = "", poll_headers : String = "", poll_frequency : String = "", poll_frequency_units : String = "") : JSON::Any
        params = {"contextName" => context_name, "checkingStrategy" => checking_strategy}
        params["pollUrl"] = poll_url unless poll_url.empty?
        params["pollData"] = poll_data unless poll_data.empty?
        params["pollHeaders"] = poll_headers unless poll_headers.empty?
        params["pollFrequency"] = poll_frequency unless poll_frequency.empty?
        params["pollFrequencyUnits"] = poll_frequency_units unless poll_frequency_units.empty?
        @client.request("/JSON/context/action/setContextCheckingStrategy/", params)
      end

      def set_context_regexs(context_name : String, inc_regexs : String, exc_regexs : String) : JSON::Any
        @client.request("/JSON/context/action/setContextRegexs/", {"contextName" => context_name, "incRegexs" => inc_regexs, "excRegexs" => exc_regexs})
      end
    end
  end
end
