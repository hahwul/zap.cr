module Zap
  module Api
    class Search
      def initialize(@client : Zap::Client)
      end

      # Views - Messages
      def messages_by_url_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByUrlRegex/", regex, base_url, start, count)
      end

      def messages_by_request_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByRequestRegex/", regex, base_url, start, count)
      end

      def messages_by_response_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByResponseRegex/", regex, base_url, start, count)
      end

      def messages_by_header_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByHeaderRegex/", regex, base_url, start, count)
      end

      def messages_by_tag_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByTagRegex/", regex, base_url, start, count)
      end

      def messages_by_note_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/messagesByNoteRegex/", regex, base_url, start, count)
      end

      # Views - URLs
      def urls_by_url_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByUrlRegex/", regex, base_url, start, count)
      end

      def urls_by_request_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByRequestRegex/", regex, base_url, start, count)
      end

      def urls_by_response_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByResponseRegex/", regex, base_url, start, count)
      end

      def urls_by_header_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByHeaderRegex/", regex, base_url, start, count)
      end

      def urls_by_tag_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByTagRegex/", regex, base_url, start, count)
      end

      def urls_by_note_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : JSON::Any
        build_search_request("/JSON/search/view/urlsByNoteRegex/", regex, base_url, start, count)
      end

      # Other - HAR export
      def har_by_url_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByUrlRegex/", regex, base_url, start, count)
      end

      def har_by_request_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByRequestRegex/", regex, base_url, start, count)
      end

      def har_by_response_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByResponseRegex/", regex, base_url, start, count)
      end

      def har_by_header_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByHeaderRegex/", regex, base_url, start, count)
      end

      def har_by_tag_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByTagRegex/", regex, base_url, start, count)
      end

      def har_by_note_regex(regex : String, base_url : String = "", start : Int32 = -1, count : Int32 = -1) : String
        build_search_request_other("/OTHER/search/other/harByNoteRegex/", regex, base_url, start, count)
      end

      private def build_search_request(path : String, regex : String, base_url : String, start : Int32, count : Int32) : JSON::Any
        params = {"regex" => regex}
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request(path, params)
      end

      private def build_search_request_other(path : String, regex : String, base_url : String, start : Int32, count : Int32) : String
        params = {"regex" => regex}
        params["baseurl"] = base_url unless base_url.empty?
        params["start"] = start.to_s if start >= 0
        params["count"] = count.to_s if count >= 0
        @client.request_other(path, params)
      end
    end
  end
end
