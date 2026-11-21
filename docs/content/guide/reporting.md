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
  sites: "http://target.com/",
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
  sites: "http://target.com/",
  included_risks: "High|Medium",
  included_confidences: "High|Confirmed",
  sections: "alertcount|alertdetails",
  report_file_name: "scan-report.html",
  report_dir: "/tmp/reports",
  display: false
)
```

Separate multiple context names, site URLs, sections, risks, and confidence
levels with `|`. ZAP uses URL prefixes for site selection. Include the slash
after the host to select that origin's paths, for example `http://target.com/`.

## Exporting Data

### HAR Export

```crystal
# Export the entire capture
client.exim.export_har

# Export one site's traffic as HAR
client.exim.export_har(base_url: "http://target.com")

# Export a directory as a raw HAR string
client.exim.export_site_messages_har("http://target.com/api/")
```

Scoped HAR exports accept an origin or a directory URL ending in `/`.
Use `export_har_by_id` to export specific messages.

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
