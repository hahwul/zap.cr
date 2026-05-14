require "../src/zap"

client = Zap::Client.new(
  base_url: ENV.fetch("ZAP_URL", "http://localhost:8080"),
  api_key: ENV.fetch("ZAP_API_KEY", ""),
)

# Run any scans you want before generating the report.
# This example assumes alerts already exist in the current session.

result = client.reports.generate(
  title: "zap.cr example report",
  template: "traditional-html",
  report_file_name: "zap-report",
  report_dir: Dir.current,
)

puts "Report generated:"
puts result.to_pretty_json

client.close
