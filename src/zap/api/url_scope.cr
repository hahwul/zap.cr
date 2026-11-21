module Zap
  module Api
    # :nodoc:
    module UrlScope
      private def directory_url(url : String) : String
        uri = URI.parse(url)
        unless uri.scheme.in?("http", "https") && (host = uri.host) && !host.empty? &&
               !uri.user && !uri.password && !uri.query && !uri.fragment
          raise Zap::Error.new("URL scope requires an absolute HTTP(S) URL without credentials, a query, or a fragment")
        end

        # ZAP matches URL prefixes literally. The slash delimits a host or
        # path segment so that the prefix cannot also match a sibling.
        uri.path = "/" if uri.path.empty?
        unless uri.path.ends_with?('/')
          raise Zap::Error.new("URL scope requires a directory path ending in /")
        end
        uri.to_s
      rescue URI::Error
        raise Zap::Error.new("Invalid URL scope")
      end
    end
  end
end
