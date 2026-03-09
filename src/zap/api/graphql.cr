module Zap
  module Api
    class Graphql
      def initialize(@client : Zap::Client)
      end

      # Actions
      def import_file(file : String, endpoint : String = "") : JSON::Any
        params = {"file" => file}
        params["endurl"] = endpoint unless endpoint.empty?
        @client.request("/JSON/graphql/action/importFile/", params)
      end

      def import_url(url : String, endpoint : String = "") : JSON::Any
        params = {"url" => url}
        params["endurl"] = endpoint unless endpoint.empty?
        @client.request("/JSON/graphql/action/importUrl/", params)
      end

      def set_option_args_type(args_type : String) : JSON::Any
        @client.request("/JSON/graphql/action/setOptionArgsType/", {"String" => args_type})
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
