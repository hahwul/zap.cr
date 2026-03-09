+++
title = "Spider"
weight = 3
+++

Traditional HTTP-based web crawler.

**Accessor:** `client.spider`

## Actions

| Method | Description |
|--------|-------------|
| `scan(url, context_name, subtree_only, in_scope)` | Start spidering |
| `scan_as_user(context_name, user_name, url, subtree_only)` | Spider as user |
| `pause(scan_id)` | Pause spider |
| `pause_all` | Pause all spiders |
| `resume(scan_id)` | Resume spider |
| `resume_all` | Resume all |
| `stop(scan_id)` | Stop spider |
| `stop_all` | Stop all spiders |
| `exclude_from_scan(regex)` | Exclude URL pattern |
| `clear_excluded_from_scan` | Clear exclusions |
| `add_allowed_resource(regex, enabled)` | Allow resource pattern |
| `remove_allowed_resource(regex)` | Remove allowed resource |
| `remove_all_allowed_resources` | Clear allowed resources |

### Options

| Method | Description |
|--------|-------------|
| `set_option_max_depth(depth)` | Max crawl depth |
| `set_option_max_children(max)` | Max children per node |
| `set_option_max_duration(minutes)` | Max duration in minutes |
| `set_option_max_parse_size_bytes(bytes)` | Max response parse size |
| `set_option_user_agent(ua)` | Custom User-Agent |
| `set_option_request_wait_time(ms)` | Delay between requests |
| `set_option_parse_comments(bool)` | Parse HTML comments |
| `set_option_parse_robots_txt(bool)` | Parse robots.txt |
| `set_option_post_form(bool)` | Submit POST forms |
| `set_option_process_form(bool)` | Process forms |
| `set_option_send_referer_header(bool)` | Send Referer header |

## Views

| Method | Description |
|--------|-------------|
| `status(scan_id)` | Spider progress (0-100) |
| `results(start, count)` | Discovered URLs |
| `full_results` | Complete results |
| `number_of_results` | URL count |
| `excluded_from_scan` | Exclusion list |
| `allowed_resources` | Allowed resources |
| `option_max_depth` | Current max depth |
| `option_max_children` | Current max children |
| `option_max_duration` | Current max duration |
| `option_user_agent` | Current User-Agent |

## Example

```crystal
result = client.spider.scan(url: "http://target.com")
scan_id = result["scan"].as_s.to_i

loop do
  progress = client.spider.status(scan_id)["status"].as_s.to_i
  break if progress >= 100
  sleep 2.seconds
end

urls = client.spider.results
```
