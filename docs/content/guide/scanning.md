+++
title = "Scanning"
weight = 1
+++

zap.cr provides both high-level convenience methods and direct API access for scanning.

## Convenience Scan Methods

The `Zap::Scan` class offers pre-built workflows accessible via `client.scan`.

### Full Scan

Runs Spider → Ajax Spider → Active Scan sequentially:

```crystal
result = client.scan.full("http://target.com") do |phase, progress|
  puts "[#{phase}] #{progress}%"
end
```

### Spider + Active Scan

Skips Ajax Spider for faster scans:

```crystal
result = client.scan.spider_and_scan("http://target.com") do |phase, progress|
  puts "[#{phase}] #{progress}%"
end
```

### Active Scan Only

Useful when the site tree is already populated:

```crystal
result = client.scan.active("http://target.com") do |phase, progress|
  puts "[ascan] #{progress}%"
end
```

### With Context

```crystal
result = client.scan.full("http://target.com", context_name: "my-context")
```

### Custom Poll Interval

```crystal
result = client.scan.full("http://target.com", poll_interval: 10.seconds)
```

## Direct Active Scan

For fine-grained control, use the `ascan` API directly:

```crystal
# Start scan with options
result = client.ascan.scan(
  url: "http://target.com",
  recurse: true,
  in_scope_only: false,
  scan_policy_name: "custom-policy",
  context_id: 1
)
scan_id = result["scan"].as_s.to_i

# Poll for completion
loop do
  status = client.ascan.status(scan_id)
  progress = status["status"].as_s.to_i
  puts "Progress: #{progress}%"
  break if progress >= 100
  sleep 5.seconds
end
```

### Scan as User

Run an active scan as a specific authenticated user:

```crystal
result = client.ascan.scan_as_user(
  "http://target.com",
  context_id: 1,
  user_id: 0,
  recurse: true
)
```

### Scan Policies

```crystal
# Create a policy
client.ascan.add_scan_policy("fast-scan",
  alert_threshold: "MEDIUM",
  attack_strength: "LOW"
)

# List policies
client.ascan.scan_policy_names

# Use policy in scan
client.ascan.scan(url: "http://target.com", scan_policy_name: "fast-scan")

# Remove policy
client.ascan.remove_scan_policy("fast-scan")
```

### Scanner Management

```crystal
# List all scanners
client.ascan.scanners

# Enable/disable specific scanners
client.ascan.enable_scanners("40012,40014,40018")
client.ascan.disable_scanners("90019")

# Enable/disable all
client.ascan.enable_all_scanners
client.ascan.disable_all_scanners
```

## Passive Scan

The passive scanner runs automatically as ZAP proxies traffic. You can wait for it to finish:

```crystal
client.scan.wait_for_passive_scan do |remaining|
  puts "Records remaining: #{remaining}"
end
```

Or manage it directly:

```crystal
# Check remaining records
client.pscan.records_to_scan

# Enable/disable passive scanners
client.pscan.enable_all_scanners
client.pscan.disable_scanners("10010,10011")

# Scope control
client.pscan.set_option_scan_only_in_scope(true)
```

## Scan Control

```crystal
# Pause/resume
client.ascan.pause(scan_id)
client.ascan.resume(scan_id)

# Stop
client.ascan.stop(scan_id)
client.ascan.stop_all

# Remove completed scans
client.ascan.remove_scan(scan_id)
client.ascan.remove_all_scans
```
