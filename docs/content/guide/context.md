+++
title = "Context Management"
weight = 4
+++

Contexts define the scope of a scan by specifying which URLs to include/exclude.

## Creating Contexts

```crystal
result = client.context.new_context("my-app")
ctx_id = result["contextId"].as_s.to_i
```

## URL Scope

Include and exclude URLs using regex patterns:

```crystal
# Include target domain
client.context.include_in_context("my-app", "http://target\\.com.*")

# Exclude specific paths
client.context.exclude_from_context("my-app", ".*logout.*")
client.context.exclude_from_context("my-app", ".*\\.pdf$")
```

## Listing Contexts

```crystal
# List all contexts
client.context.context_list

# Get context details
client.context.context("my-app")

# Get include/exclude regexes
client.context.included_regexs("my-app")
client.context.excluded_regexs("my-app")

# Get URLs in context
client.context.urls("my-app")
```

## Technology Filtering

Limit scanning to specific technologies:

```crystal
# List available technologies
client.context.technology_list

# Include specific technologies
client.context.include_context_technologies("my-app", "Language.PHP,Db.MySQL")

# Exclude technologies
client.context.exclude_context_technologies("my-app", "Language.Java")
```

## Scope

```crystal
client.context.set_context_in_scope("my-app", true)
```

## Import / Export

```crystal
# Export context configuration
client.context.export_context("my-app", "/tmp/my-app-context.xml")

# Import context
client.context.import_context("/tmp/my-app-context.xml")
```

## Cleanup

```crystal
client.context.remove_context("my-app")
```
