# Changelog

## v0.2.0

- `Api::ClientSpider#scan` now accepts `url`, `browser`, `context_name`, `user_name`,
  `subtree_only`, `max_crawl_depth`, `page_load_time`, `action_wait_time`,
  `number_of_browsers`, `scope_check`, and `logout_avoidance`, and returns the scan id.
- `Api::ClientSpider#stop` and `#status` now accept an optional `scan_id`.
- `Api::Postman#import_file` and `#import_url` now send the required `file`/`url`
  parameters (previously sent no parameters and were non-functional).

## v0.1.0

- Initial release
