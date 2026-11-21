module Zap
  module Api
    class Graphql
      def initialize(@client : Zap::Client)
      end

      # Actions
      # ZAP requires the endpoint when importing a schema from a file.
      def import_file(file : String, endpoint : String = "", *, max_messages : Int32? = nil) : JSON::Any
        params = {"file" => file}
        params["endurl"] = endpoint unless endpoint.empty?
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/graphql/action/importFile/", params)
      end

      # ZAP requires `endurl` (the endpoint the generated queries go to); `url`
      # is where to fetch the schema from. Without an `endpoint`, `url` is the
      # GraphQL endpoint itself, so it is sent as `endurl` and ZAP introspects
      # it. Sending it as `url` alone was always rejected as missing `endurl`.
      def import_url(url : String, endpoint : String = "", *, max_messages : Int32? = nil) : JSON::Any
        params = endpoint.empty? ? {"endurl" => url} : {"url" => url, "endurl" => endpoint}
        params["maxMessages"] = max_messages.to_s if max_messages
        @client.request("/JSON/graphql/action/importUrl/", params)
      end

      def set_option_args_type(args_type : String) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionArgsType/", {"String" => args_type})
      end

      def set_option_cycle_detection_mode(mode : String) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionCycleDetectionMode/", {"String" => mode})
      end

      def set_option_max_cycle_detection_alerts(max : Int32) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionMaxCycleDetectionAlerts/", {"Integer" => max.to_s})
      end

      def set_option_max_query_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionMaxQueryDepth/", {"Integer" => depth.to_s})
      end

      def set_option_max_additional_query_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionMaxAdditionalQueryDepth/", {"Integer" => depth.to_s})
      end

      def set_option_max_args_depth(depth : Int32) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionMaxArgsDepth/", {"Integer" => depth.to_s})
      end

      def set_option_optional_args_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionOptionalArgsEnabled/", {"Boolean" => enabled.to_s})
      end

      def set_option_query_gen_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionQueryGenEnabled/", {"Boolean" => enabled.to_s})
      end

      def set_option_query_split_type(split_type : String) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionQuerySplitType/", {"String" => split_type})
      end

      def set_option_request_method(method : String) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionRequestMethod/", {"String" => method})
      end

      def set_option_lenient_max_query_depth_enabled(enabled : Bool) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionLenientMaxQueryDepthEnabled/", {"Boolean" => enabled.to_s})
      end

      # Views
      def option_args_type : JSON::Any
        @client.request("/JSON/graphql/view/optionArgsType/")
      end

      def option_cycle_detection_mode : JSON::Any
        @client.request("/JSON/graphql/view/optionCycleDetectionMode/")
      end

      def option_max_cycle_detection_alerts : JSON::Any
        @client.request("/JSON/graphql/view/optionMaxCycleDetectionAlerts/")
      end

      def option_max_query_depth : JSON::Any
        @client.request("/JSON/graphql/view/optionMaxQueryDepth/")
      end

      def option_max_additional_query_depth : JSON::Any
        @client.request("/JSON/graphql/view/optionMaxAdditionalQueryDepth/")
      end

      def option_max_args_depth : JSON::Any
        @client.request("/JSON/graphql/view/optionMaxArgsDepth/")
      end

      def option_optional_args_enabled : JSON::Any
        @client.request("/JSON/graphql/view/optionOptionalArgsEnabled/")
      end

      def option_query_gen_enabled : JSON::Any
        @client.request("/JSON/graphql/view/optionQueryGenEnabled/")
      end

      def option_query_split_type : JSON::Any
        @client.request("/JSON/graphql/view/optionQuerySplitType/")
      end

      def option_request_method : JSON::Any
        @client.request("/JSON/graphql/view/optionRequestMethod/")
      end

      def option_lenient_max_query_depth_enabled : JSON::Any
        @client.request("/JSON/graphql/view/optionLenientMaxQueryDepthEnabled/")
      end
    end
  end
end
