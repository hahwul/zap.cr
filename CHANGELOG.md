# Changelog

## Unreleased

### Fixed

- `Client#request` / `#request_other` no longer write the API key into the
  `Hash` the caller passed in, which planted the secret in a caller-owned
  object and could resend a stale key from a reused hash.
- `Scan`'s ajax spider poll loop no longer raises `TypeCastError` when
  `ajaxSpider/view/status` answers anything other than a JSON string — most
  importantly `null`, which is what ZAP returns before the ajax spider has ever
  been started.
- A path prefix in `base_url` (e.g. `https://ci.example/zap`, a reverse-proxied
  daemon) is now kept on every request instead of being silently dropped.
- `ZAP_URL` / `ZAP_API_KEY` no longer override values passed explicitly to
  `Client.new`. Both parameters now default to `nil`; passing a value always
  wins, even when it equals the built-in default.
- `Client#close` takes the request lock, so closing from one fiber while
  another is mid-request no longer tears the socket out from under it.
- `Scan`'s alert-returning workflows (`full`, `spider_and_scan`, `active`) wait
  for the passive-scan queue to drain before reading the alerts summary, which
  previously under-reported passive findings on every run. Opt out with
  `wait_for_passive: false`.
- `Api::Core#alerts` / `#number_of_alerts` accept `Int32` and `Zap::Risk` for
  the filter parameters, matching `Api::Alert`. The previous `String`-only form
  still works.
- `Api::Spider#scan_as_user` sends the `contextId` / `userId` that ZAP's action
  requires (it accepts no `contextName` / `userName`, so every call previously
  failed), and forwards `recurse` / `max_children`.
- `Api::Spider#full_results` sends the mandatory `scanId`; previously it sent
  none and always failed, which also broke `Scan#spider` and `Scan#spider_full`
  at their final step. `Api::Spider#results` takes `scan_id` instead of the
  `start` / `count` pair that ZAP ignores.

### Added

- Optional `timeout` on every `Scan` workflow, bounding the poll loops that
  could otherwise wait forever on a stalled scan. Raises the new
  `Zap::TimeoutError`.
- `Zap::Client::DEFAULT_BASE_URL`.

## v0.2.0

- `Api::ClientSpider#scan` now accepts `url`, `browser`, `context_name`, `user_name`,
  `subtree_only`, `max_crawl_depth`, `page_load_time`, `action_wait_time`,
  `number_of_browsers`, `scope_check`, and `logout_avoidance`, and returns the scan id.
- `Api::ClientSpider#stop` and `#status` now accept an optional `scan_id`.
- `Api::Postman#import_file` and `#import_url` now send the required `file`/`url`
  parameters (previously sent no parameters and were non-functional).

## v0.1.0

- Initial release
