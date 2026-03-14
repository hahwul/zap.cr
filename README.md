# zap.cr

Crystal client library for [OWASP ZAP](https://www.zaproxy.org/) API.

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
