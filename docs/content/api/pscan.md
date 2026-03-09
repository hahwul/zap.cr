+++
title = "Passive Scan"
weight = 6
+++

Passive scanner that analyzes traffic without sending additional requests.

**Accessor:** `client.pscan`

## Actions

| Method | Description |
|--------|-------------|
| `enable_all_scanners` | Enable all passive scanners |
| `disable_all_scanners` | Disable all passive scanners |
| `enable_scanners(ids)` | Enable specific scanners (comma-separated IDs) |
| `disable_scanners(ids)` | Disable specific scanners |
| `set_option_max_alerts_per_rule(max)` | Max alerts per rule |
| `set_option_scan_only_in_scope(enabled)` | Scope-only scanning |

## Views

| Method | Description |
|--------|-------------|
| `scanners` | List all passive scanners |
| `records_to_scan` | Remaining records to scan |
| `option_max_alerts_per_rule` | Current max alerts setting |
| `option_scan_only_in_scope` | Current scope setting |

## Example

```crystal
# Wait for passive scan to complete
loop do
  remaining = client.pscan.records_to_scan["recordsToScan"].as_s.to_i
  break if remaining == 0
  puts "Passive scan: #{remaining} records remaining"
  sleep 2.seconds
end
```
