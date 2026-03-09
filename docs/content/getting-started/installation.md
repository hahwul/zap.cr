+++
title = "Installation"
weight = 1
+++

## Add to shard.yml

Add `zap` as a dependency in your `shard.yml`:

```yaml
dependencies:
  zap:
    github: hahwul/zap.cr
```

Then run:

```bash
shards install
```

## Require in Your Code

```crystal
require "zap"
```

## ZAP Setup

zap.cr connects to a running ZAP instance via its REST API. You can start ZAP in several ways:

### Docker (Recommended)

```bash
docker run -u zap -p 8080:8080 \
  ghcr.io/zaproxy/zaproxy:stable \
  zap.sh -daemon -host 0.0.0.0 -port 8080 \
  -config api.key=your-api-key \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true
```

### Desktop

1. Download ZAP from [zaproxy.org](https://zaproxy.org/download/)
2. Launch ZAP
3. Go to Tools > Options > API
4. Note the API key

### Headless

```bash
zap.sh -daemon -port 8080 -config api.key=your-api-key
```

## Next Steps

Proceed to the [Quick Start](/getting-started/quick-start/) guide.
