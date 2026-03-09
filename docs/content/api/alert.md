+++
title = "Alert"
weight = 7
+++

Manage security findings (alerts) from scans.

**Accessor:** `client.alert`

## Views

| Method | Description |
|--------|-------------|
| `get(id)` | Single alert by ID |
| `alerts(base_url, start, count, risk_id, context_name)` | List alerts with filters |
| `alerts_summary(base_url)` | Summary counts by risk |
| `number_of_alerts(base_url, risk_id)` | Alert count |
| `alerts_by_risk(url, recurse)` | Alerts grouped by risk |
| `alert_counts_by_risk(url, recurse)` | Count per risk level |

## Actions

| Method | Description |
|--------|-------------|
| `delete_alert(id)` | Delete single alert |
| `delete_alerts(context_name, base_url, risk_id)` | Delete by criteria |
| `delete_all_alerts` | Delete all alerts |
| `update_alert(id, name, risk_id, confidence_id, description, ...)` | Update alert details |
| `update_alerts_confidence(ids, confidence_id)` | Batch update confidence |
| `update_alerts_risk(ids, risk_id)` | Batch update risk |

### Risk Levels

| Value | Level |
|-------|-------|
| 0 | Informational |
| 1 | Low |
| 2 | Medium |
| 3 | High |

### Confidence Levels

| Value | Level |
|-------|-------|
| 0 | False Positive |
| 1 | Low |
| 2 | Medium |
| 3 | High |
| 4 | Confirmed |

## Example

```crystal
# Get high-risk alerts
alerts = client.alert.alerts(base_url: "http://target.com", risk_id: 3)
alerts["alerts"].as_a.each do |a|
  puts "#{a["name"]} - #{a["url"]}"
end
```
