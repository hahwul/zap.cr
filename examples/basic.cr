require "../src/zap"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

puts "ZAP version: #{client.core.version["version"]}"
puts "Mode:        #{client.core.mode["mode"]}"
puts "Sites:       #{client.core.sites["sites"]}"

client.close
