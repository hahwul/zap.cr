+++
title = "Active Scan"
weight = 5
+++

Active vulnerability scanner that sends attack payloads to the target.

**Accessor:** `client.ascan`

## Scan Actions

| Method | Description |
|--------|-------------|
| `scan(url, recurse, in_scope_only, scan_policy_name, method, post_data, context_id)` | Start active scan |
| `scan_as_user(url, context_id, user_id, recurse, scan_policy_name, method, post_data)` | Scan as user |
| `pause(scan_id)` | Pause scan |
| `pause_all` | Pause all scans |
| `resume(scan_id)` | Resume scan |
| `resume_all` | Resume all |
| `stop(scan_id)` | Stop scan |
| `stop_all` | Stop all scans |
| `remove_scan(scan_id)` | Remove completed scan |
| `remove_all_scans` | Remove all scans |

## Policy Actions

| Method | Description |
|--------|-------------|
| `add_scan_policy(name, alert_threshold, attack_strength)` | Create policy |
| `remove_scan_policy(name)` | Remove policy |
| `set_enabled_policies(ids, scan_policy_name)` | Enable policies |
| `set_policy_attack_strength(id, strength, scan_policy_name)` | Set attack strength |
| `set_policy_alert_threshold(id, threshold, scan_policy_name)` | Set alert threshold |

## Scanner Actions

| Method | Description |
|--------|-------------|
| `enable_scanners(ids, scan_policy_name)` | Enable scanners by ID |
| `disable_scanners(ids, scan_policy_name)` | Disable scanners by ID |
| `enable_all_scanners(scan_policy_name)` | Enable all |
| `disable_all_scanners(scan_policy_name)` | Disable all |
| `set_scanner_attack_strength(id, strength, scan_policy_name)` | Per-scanner strength |
| `set_scanner_alert_threshold(id, threshold, scan_policy_name)` | Per-scanner threshold |

## Option Actions

| Method | Description |
|--------|-------------|
| `set_option_thread_per_host(n)` | Threads per host |
| `set_option_host_per_scan(n)` | Hosts per scan |
| `set_option_delay_in_ms(ms)` | Delay between requests |
| `set_option_max_results_to_list(n)` | Max results |
| `exclude_from_scan(regex)` | Exclude URL pattern |
| `clear_excluded_from_scan` | Clear exclusions |

## Views

| Method | Description |
|--------|-------------|
| `status(scan_id)` | Scan progress (0-100) |
| `scan_progress(scan_id)` | Detailed progress |
| `messages_ids(scan_id)` | Message IDs for scan |
| `alerts_ids(scan_id)` | Alert IDs for scan |
| `scans` | All scans |
| `scan_policy_names` | Policy names |
| `scanners(scan_policy_name, policy_id)` | Scanner list |
| `policies(scan_policy_name, policy_id)` | Policy list |
| `excluded_from_scan` | Exclusions |
| `option_thread_per_host` | Current threads setting |
| `option_host_per_scan` | Current hosts setting |
| `option_delay_in_ms` | Current delay |

## Example

```crystal
result = client.ascan.scan(url: "http://target.com", recurse: true)
scan_id = result["scan"].as_s.to_i

loop do
  progress = client.ascan.status(scan_id)["status"].as_s.to_i
  puts "Active Scan: #{progress}%"
  break if progress >= 100
  sleep 5.seconds
end
```
