require "../src/zap"

target = ARGV[0]? || "https://example.com"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

puts "Summary for #{target}:"
puts client.alert.alerts_summary(target).to_pretty_json

puts "\nFirst 10 alerts:"
alerts = client.alert.alerts(base_url: target, start: 0, count: 10)
(alerts["alerts"]?.try(&.as_a) || [] of JSON::Any).each do |a|
  puts "[#{a["risk"]}] #{a["alert"]} - #{a["url"]}"
end

client.close
