# Changelog

## Unreleased

Bug fixes from auditing every endpoint against the ZAP API.

### Fixed

- `Client` no longer writes `apikey` into the caller's params hash, which
  leaked the key into a structure the caller may log and re-sent a stale key
  after `api_key` was rotated. An explicitly supplied `apikey` now wins.
- `Client#close` is serialized with in-flight requests, so closing from another
  fiber can no longer tear down the socket mid-request.
- `Api::Spider#scan_as_user` sends `contextId`/`userId` (ZAP does not accept
  names here) and gained `recurse`/`max_children`. **Breaking**: takes ids.
- `Api::Spider#results` / `#full_results` take a `scan_id`; the previous
  `start`/`count` were silently ignored by ZAP. **Breaking**.
- `Api::ForcedUser#enabled?` / `#set_enabled` and `Api::AlertFilter`
  `#apply_context` / `#test_context` no longer take a context id — all four
  are global in ZAP. **Breaking**.
- `Api::Core#set_option_maximum_alert_instances` sends `numberOfInstances`.
- Endpoints that ZAP requires arguments for now take them (previously every
  call failed): `Api::RuleConfig`, `Api::Retest#retest`,
  `Api::Wappalyzer#list_site`, `Api::Revisit`, `Api::CustomPayloads`,
  `Api::LocalProxies`, `Api::Oast` setters, `Api::Client` report actions,
  `Api::Pnh`, and `Api::AccessControl#scan` (needs `user_id`). **Breaking**.
- `Scan` workflows accept an optional `timeout`; without one a scan ZAP has
  forgotten polled forever. Progress values that are JSON floats or
  float-shaped strings are parsed instead of reading as 0, and a non-string
  ajax spider status no longer raises `TypeCastError`.

### Added

- `Api::AlertFilter` add/remove gained `parameter_is_regex`, `attack`,
  `attack_is_regex`, `evidence`, `evidence_is_regex` and `methods`, and
  `new_level` accepts a `Zap::Risk`.
- `Api::Alert#alerts` gained the `false_positive` filter.
- `Api::OpenApi` imports gained `user_id`; `Api::Script#load` gained
  `charset`; `Api::Replacer#add_rule` gained `url`/`method`;
  `Api::AjaxSpider#add_excluded_element` gained the xpath/text/attribute
  criteria; `Api::Client` gained the passive-scan options.

## v0.2.0

- `Api::ClientSpider#scan` now accepts `url`, `browser`, `context_name`, `user_name`,
  `subtree_only`, `max_crawl_depth`, `page_load_time`, `action_wait_time`,
  `number_of_browsers`, `scope_check`, and `logout_avoidance`, and returns the scan id.
- `Api::ClientSpider#stop` and `#status` now accept an optional `scan_id`.
- `Api::Postman#import_file` and `#import_url` now send the required `file`/`url`
  parameters (previously sent no parameters and were non-functional).

## v0.1.0

- Initial release
