+++
title = "Ajax Spider"
weight = 4
+++

Browser-based crawler for JavaScript-heavy applications.

**Accessor:** `client.ajax_spider`

## Actions

| Method | Description |
|--------|-------------|
| `scan(url, in_scope, context_name, subtree_only)` | Start Ajax spidering |
| `scan_as_user(context_name, user_name, url, subtree_only)` | Spider as user |
| `stop` | Stop the Ajax spider |
| `add_allowed_resource(regex, enabled)` | Allow resource |
| `remove_allowed_resource(regex)` | Remove allowed resource |
| `set_enabled_allowed_resource(regex, enabled)` | Toggle resource |
| `add_excluded_element(context_name, description, element)` | Exclude element |
| `remove_excluded_element(context_name, description)` | Remove exclusion |

### Options

| Method | Description |
|--------|-------------|
| `set_option_browser_id(browser)` | Browser to use (e.g. `firefox-headless`) |
| `set_option_max_crawl_depth(depth)` | Max crawl depth |
| `set_option_max_crawl_states(states)` | Max crawl states (0=unlimited) |
| `set_option_max_duration(minutes)` | Max duration |
| `set_option_number_of_browsers(n)` | Parallel browsers |
| `set_option_click_default_elems(bool)` | Click default elements |
| `set_option_click_elems_once(bool)` | Click each element once |
| `set_option_event_wait(ms)` | Wait after events |
| `set_option_reload_wait(ms)` | Wait after page reload |
| `set_option_random_inputs(bool)` | Use random inputs |

## Views

| Method | Description |
|--------|-------------|
| `status` | Running status (`"running"` / `"stopped"`) |
| `results(start, count)` | Crawled resources |
| `full_results` | Complete results |
| `number_of_results` | Result count |
| `allowed_resources` | Allowed resources list |
| `option_browser_id` | Current browser |
| `option_max_crawl_depth` | Current depth limit |
| `option_max_crawl_states` | Current states limit |
| `option_max_duration` | Current duration limit |
| `option_number_of_browsers` | Current browser count |

## Example

```crystal
client.ajax_spider.scan(url: "http://spa-app.com")

loop do
  status = client.ajax_spider.status["status"].as_s
  break if status != "running"
  sleep 5.seconds
end

results = client.ajax_spider.full_results
```
