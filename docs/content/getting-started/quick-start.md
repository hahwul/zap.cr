+++
title = "Quick Start"
weight = 2
+++

## Create a Client

```crystal
require "zap"

client = Zap::Client.new("http://localhost:8080", "your-api-key")
```

The first argument is the ZAP base URL, the second is the API key.

## Verify Connection

```crystal
version = client.core.version
puts version  # => {"version": "2.15.0"}
```

## Run a Full Scan

The simplest way to scan a target is `scan.full`, which runs Spider, Ajax Spider, and Active Scan sequentially:

```crystal
result = client.scan.full("http://target.com") do |phase, progress|
  puts "[#{phase}] #{progress}%"
end

puts result
```

Output:

```
[spider] 0%
[spider] 45%
[spider] 100%
[ajaxSpider] 0%
[ajaxSpider] 100%
[ascan] 0%
[ascan] 25%
[ascan] 50%
[ascan] 75%
[ascan] 100%
{"alertsSummary": {"High": 2, "Medium": 5, "Low": 8, "Informational": 12}}
```

## Get Alerts

```crystal
alerts = client.alert.alerts(base_url: "http://target.com")
alerts["alerts"].as_a.each do |alert|
  risk = alert["risk"].as_s
  name = alert["name"].as_s
  url = alert["url"].as_s
  puts "[#{risk}] #{name} - #{url}"
end
```

## Direct API Access

Every ZAP API endpoint is accessible through the client:

```crystal
# Spider a target
scan_id = client.spider.scan(url: "http://target.com")

# Check spider status
status = client.spider.status(0)

# Run active scan
scan_id = client.ascan.scan(url: "http://target.com")

# Get scan progress
progress = client.ascan.status(0)
```

## Next Steps

- [Configuration](/getting-started/configuration/) - Client options and tuning
- [Scanning Guide](/guide/scanning/) - Detailed scanning workflows
- [API Reference](/api/) - Complete API documentation
