+++
title = "Reporting"
weight = 6
+++

Generate reports from scan results using ZAP's built-in reporting engine.

## Generate a Report

```crystal
client.reports.generate(
  title: "Security Scan Report",
  template: "traditional-html",
  sites: "http://target.com",
  report_dir: "/tmp/reports"
)
```

## Available Templates

```crystal
templates = client.reports.templates
```

Get details about a specific template:

```crystal
client.reports.template_details("traditional-html")
```

## Report Options

```crystal
client.reports.generate(
  title: "High Risk Report",
  template: "traditional-html",
  description: "Scan results for target.com",
  sites: "http://target.com",
  included_risks: "High,Medium",           # filter by risk
  included_confidences: "High,Confirmed",   # filter by confidence
  sections: "alertcount,alertdetails",       # specific sections
  report_file_name: "scan-report.html",
  report_dir: "/tmp/reports",
  display: false
)
```

## Exporting Data

### HAR Export

```crystal
# Export all traffic as HAR
client.exim.export_har(base_url: "http://target.com")
```

### Search and Export

```crystal
# Search HAR by URL pattern
client.search.har_by_url_regex(".*target\\.com.*")

# Search HAR by response content
client.search.har_by_response_regex("password")
```

## Importing Data

```crystal
# Import URLs from file
client.exim.import_urls("/path/to/urls.txt")

# Import HAR file
client.exim.import_har("/path/to/traffic.har")

# Import OpenAPI spec
client.openapi.import_url("http://target.com/openapi.json")
client.openapi.import_file("/path/to/openapi.yaml")

# Import GraphQL schema
client.graphql.import_url("http://target.com/graphql")

# Import SOAP WSDL
client.soap.import_url("http://target.com/service?wsdl")
```
