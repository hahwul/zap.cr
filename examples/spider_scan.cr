require "../src/zap"

target = ARGV[0]? || "https://example.com"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

results = client.scan.spider(target) do |phase, progress|
  puts "[#{phase}] #{progress}%"
end

# `spider/view/fullResults` replies {"fullResults": [{"urlsInScope": [...]},
# {"urlsOutOfScope": [...]}, {"urlsIoError": [...]}]}.
groups = results["fullResults"]?.try(&.as_a) || [] of JSON::Any
urls = groups.flat_map { |group| group["urlsInScope"]?.try(&.as_a) || [] of JSON::Any }
puts "Discovered #{urls.size} URLs:"
urls.first(20).each { |u| puts "  - #{u["method"]?} #{u["url"]?} (#{u["statusCode"]?})" }

client.close
