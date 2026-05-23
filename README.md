# zap.cr

Crystal client library for [ZAP](https://www.zaproxy.org/) API.

## Requirements

zap.cr talks to a running ZAP daemon over HTTP. Before using the library:

- Install and run ZAP — `zap.sh -daemon -port 8080 -config api.key=YOUR_KEY`
  (or use the official Docker image `zaproxy/zap-stable`).
- Set the daemon URL and API key via constructor arguments or environment
  variables `ZAP_URL` (default `http://localhost:8080`) and `ZAP_API_KEY`.

See [`examples/README.md`](./examples) for runnable scripts that cover spider,
active scan, alerts, contexts, and report generation.

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  zap:
    github: hahwul/zap.cr
```

Then run `shards install`.

## Usage

```crystal
require "zap"

# Initialize client
client = Zap::Client.new("http://localhost:8080", "your-api-key")
```

### API Access

```crystal
# Core
client.core.version

# Spider
client.spider.scan(url: "https://example.com")

# Active Scan
client.ascan.scan(url: "https://example.com")

# Alerts
client.alert.alerts_summary("https://example.com")
```

### Convenience Scan

```crystal
# Full scan (Spider + Ajax Spider + Active Scan)
client.scan.full("https://example.com") { |phase, progress|
  puts "#{phase}: #{progress}%"
}

# Spider + Active Scan only
client.scan.spider_and_scan("https://example.com")

# Spider only
client.scan.spider("https://example.com")
```

## Contributing

1. Fork it (<https://github.com/hahwul/zap.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [hahwul](https://github.com/hahwul) - creator and maintainer
