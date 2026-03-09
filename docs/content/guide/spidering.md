+++
title = "Spidering"
weight = 2
+++

ZAP provides two types of spiders: the traditional spider (fast, HTTP-based) and the Ajax spider (browser-based, handles JavaScript).

## Traditional Spider

### Basic Spider

```crystal
result = client.spider.scan(url: "http://target.com")
scan_id = result["scan"].as_s.to_i

# Wait for completion
loop do
  status = client.spider.status(scan_id)
  progress = status["status"].as_s.to_i
  puts "Spider: #{progress}%"
  break if progress >= 100
  sleep 2.seconds
end

# Get discovered URLs
results = client.spider.results
```

### Spider with Context

```crystal
client.spider.scan(
  url: "http://target.com",
  context_name: "my-context",
  subtree_only: true
)
```

### Spider as User

```crystal
client.spider.scan_as_user("my-context", "admin",
  url: "http://target.com"
)
```

### Spider Options

```crystal
client.spider.set_option_max_depth(10)
client.spider.set_option_max_children(100)
client.spider.set_option_max_duration(60)       # minutes
client.spider.set_option_request_wait_time(200)  # ms between requests
client.spider.set_option_user_agent("CustomBot/1.0")

# Parsing options
client.spider.set_option_parse_comments(true)
client.spider.set_option_parse_robots_txt(true)
client.spider.set_option_post_form(true)
client.spider.set_option_process_form(true)
```

### Exclusions

```crystal
# Exclude URLs matching a regex
client.spider.exclude_from_scan(".*logout.*")
client.spider.exclude_from_scan(".*\\.pdf$")

# Allow specific resources
client.spider.add_allowed_resource(".*\\.js$")

# Clear exclusions
client.spider.clear_excluded_from_scan
```

## Ajax Spider

The Ajax spider uses a real browser to crawl JavaScript-heavy applications.

### Basic Ajax Spider

```crystal
client.ajax_spider.scan(url: "http://target.com")

# Wait for completion (status is "running" or "stopped")
loop do
  status = client.ajax_spider.status
  break if status["status"].as_s != "running"
  puts "Ajax Spider running..."
  sleep 5.seconds
end

results = client.ajax_spider.results
```

### Ajax Spider Options

```crystal
# Browser selection
client.ajax_spider.set_option_browser_id("firefox-headless")

# Crawl limits
client.ajax_spider.set_option_max_crawl_depth(10)
client.ajax_spider.set_option_max_crawl_states(0)  # 0 = unlimited
client.ajax_spider.set_option_max_duration(60)       # minutes

# Performance
client.ajax_spider.set_option_number_of_browsers(2)
client.ajax_spider.set_option_event_wait(1000)   # ms
client.ajax_spider.set_option_reload_wait(1000)  # ms

# Behavior
client.ajax_spider.set_option_click_default_elems(true)
client.ajax_spider.set_option_click_elems_once(true)
client.ajax_spider.set_option_random_inputs(true)
```

## Combined Spidering

Use the convenience method to run both spiders:

```crystal
result = client.scan.spider_full("http://target.com") do |phase, progress|
  puts "[#{phase}] #{progress}%"
end
```

Or run them individually with the convenience methods:

```crystal
# Traditional spider only
client.scan.spider("http://target.com")

# Ajax spider only
client.scan.ajax_spider("http://target.com")
```
