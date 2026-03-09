+++
title = "Alerts"
weight = 5
+++

Alerts represent security findings discovered during scanning.

## Listing Alerts

```crystal
# All alerts
alerts = client.alert.alerts

# Alerts for a specific URL
alerts = client.alert.alerts(base_url: "http://target.com")

# Paginated
alerts = client.alert.alerts(start: 0, count: 50)

# By risk level (0=Info, 1=Low, 2=Medium, 3=High)
alerts = client.alert.alerts(risk_id: 3)  # High only
```

## Alert Summary

```crystal
summary = client.alert.alerts_summary("http://target.com")
# => {"alertsSummary": {"High": 2, "Medium": 5, "Low": 8, "Informational": 3}}

counts = client.alert.alert_counts_by_risk("http://target.com")
```

## Single Alert

```crystal
alert = client.alert.get(42)
```

## Iterating Alerts

```crystal
alerts = client.alert.alerts(base_url: "http://target.com")
alerts["alerts"].as_a.each do |alert|
  puts "#{alert["risk"]} | #{alert["name"]} | #{alert["url"]}"
  puts "  CWE: #{alert["cweid"]}, WASC: #{alert["wascid"]}"
  puts "  #{alert["description"]}"
  puts
end
```

## Grouped by Risk

```crystal
by_risk = client.alert.alerts_by_risk(url: "http://target.com")
```

## Managing Alerts

### Delete

```crystal
# Delete single alert
client.alert.delete_alert(42)

# Delete by criteria
client.alert.delete_alerts(
  base_url: "http://target.com",
  risk_id: 0  # delete Informational
)

# Delete all
client.alert.delete_all_alerts
```

### Update

```crystal
client.alert.update_alerts_risk("1,2,3", risk_id: 2)     # set to Medium
client.alert.update_alerts_confidence("1,2,3", confidence_id: 3)
```

## Alert Filters

Suppress or change alert risk levels based on rules:

```crystal
# Add global filter (suppress false positive)
client.alert_filter.add_global_alert_filter(
  rule_id: 10016,
  new_level: -1,  # -1 = False Positive
  url: ".*\\.css$"
)

# Context-specific filter
client.alert_filter.add_alert_filter(
  context_id: 1,
  rule_id: 10016,
  new_level: -1
)

# Apply filters
client.alert_filter.apply_all

# List filters
client.alert_filter.global_alert_filter_list
client.alert_filter.alert_filter_list(1)
```
