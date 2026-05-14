require "../src/zap"

target = ARGV[0]? || "https://example.com"
context_name = "example-ctx"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

# Recreate the context fresh.
begin
  client.context.remove_context(context_name)
rescue Zap::HttpError
end

client.context.new_context(context_name)
client.context.include_in_context(context_name, "#{Regex.escape(target)}.*")
client.context.set_context_in_scope(context_name, true)

puts "Context '#{context_name}' configured. Scanning..."
summary = client.scan.spider_and_scan(target, context_name) do |phase, progress|
  print "\r#{phase}: #{progress}%   "
end
puts

puts summary.to_pretty_json

client.close
