require "../src/zap"

target = ARGV[0]? || "https://example.com"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

results = client.scan.spider(target) do |phase, progress|
  puts "[#{phase}] #{progress}%"
end

urls = results["results"]?.try(&.as_a) || [] of JSON::Any
puts "Discovered #{urls.size} URLs:"
urls.first(20).each { |u| puts "  - #{u}" }

client.close
