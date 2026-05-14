require "../src/zap"

target = ARGV[0]? || "https://example.com"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

last_phase = ""
summary = client.scan.full(target) do |phase, progress|
  if phase != last_phase
    puts unless last_phase.empty?
    print "#{phase}: "
    last_phase = phase
  end
  print "\r#{phase}: #{progress}%"
end
puts

puts "\nFinal alerts summary:"
puts summary.to_pretty_json

client.close
