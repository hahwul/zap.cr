require "../src/zap"

target = ARGV[0]? || "https://example.com"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

# Spider first so the active scanner has URLs to attack.
puts "Spidering #{target}..."
client.scan.spider(target) { |_phase, progress| print "\rspider: #{progress}%" }
puts

puts "Running active scan..."
summary = client.scan.active(target) do |_phase, progress|
  print "\rascan: #{progress}%"
end
puts

puts "Alerts summary:"
puts summary.to_pretty_json

client.close
