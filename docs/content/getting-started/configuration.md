+++
title = "Configuration"
weight = 3
+++

## Client Options

The `Zap::Client` accepts two parameters:

```crystal
client = Zap::Client.new(
  base_url: "http://localhost:8080",  # ZAP API URL
  api_key: "your-api-key"            # API key (empty string to disable)
)
```

Both parameters have defaults:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `base_url` | `http://localhost:8080` | ZAP instance URL |
| `api_key` | `""` (empty) | API key for authentication |

## Timeouts

The client uses the following timeouts:

- **Connect timeout**: 30 seconds
- **Read timeout**: 300 seconds (5 minutes, suitable for long scans)

## Poll Interval

Convenience scan methods accept a `poll_interval` parameter:

```crystal
# Default: 5 seconds
client.scan.full("http://target.com", poll_interval: 10.seconds)
```

## ZAP Configuration

You can configure ZAP settings through the API:

### Proxy Settings

```crystal
client.network.set_http_proxy("proxy.local", 8888,
  username: "user",
  password: "pass"
)
```

### Timeouts

```crystal
client.core.set_option_timeout_in_secs(120)
client.network.set_connection_timeout(60)
```

### User Agent

```crystal
client.core.set_option_default_user_agent("CustomBot/1.0")
```

### Active Scan Tuning

```crystal
client.ascan.set_option_thread_per_host(5)
client.ascan.set_option_host_per_scan(3)
client.ascan.set_option_delay_in_ms(0)
```

### Spider Tuning

```crystal
client.spider.set_option_max_depth(10)
client.spider.set_option_max_duration(60)  # minutes
client.spider.set_option_request_wait_time(200)  # ms
```
