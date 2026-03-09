+++
title = "Zap.cr"
description = "Crystal client library for ZAP API"
+++

Crystal client library for [ZAP](https://zaproxy.org) (Zed Attack Proxy) API. Provides complete API coverage and high-level convenience methods for common security testing workflows.

## Features

- Complete ZAP API coverage with 33 API modules
- High-level scanning workflows (full scan, spider + scan, etc.)
- Progress tracking with callbacks
- Typed Crystal interface over ZAP's REST API

## Quick Example

```crystal
require "zap"

client = Zap::Client.new("http://localhost:8080", "your-api-key")

# High-level: full scan (spider + ajax spider + active scan)
result = client.scan.full("http://target.com") do |phase, progress|
  puts "[#{phase}] #{progress}%"
end

# Check results
puts result  # alerts summary
```

## Getting Started

- **[Installation](/getting-started/installation/)** - Add zap.cr to your project
- **[Quick Start](/getting-started/quick-start/)** - Run your first scan
- **[Configuration](/getting-started/configuration/)** - Client options

## Guide

- **[Scanning](/guide/scanning/)** - Full scan, active scan, passive scan workflows
- **[Spidering](/guide/spidering/)** - Traditional and Ajax spidering
- **[Authentication](/guide/authentication/)** - Authenticated scanning
- **[Alerts](/guide/alerts/)** - Working with scan results

## API Reference

- **[Client](/api/client/)** - Core client class
- **[API Modules](/api/)** - All 33 API module references
