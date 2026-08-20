# Changelog

## Unreleased

Bug fixes from auditing every endpoint against the ZAP API.

### Security

- The API key is sent in the `X-ZAP-API-Key` header instead of an `apikey`
  query parameter. ZAP accepts both and checks the header first, but only the
  query form is persisted — ZAP writes the request URL to its own log, and any
  reverse proxy in front of the daemon writes it to an access log, leaving the
  key in plain text in both. Callers that put `apikey` in `params` themselves
  keep the query form, for daemons behind something that strips headers.

### Fixed

- TLS handshake failures raise `Zap::Error` instead of escaping as a raw
  `OpenSSL::SSL::Error`; `OpenSSL::Error` descends from `Exception`, not
  `IO::Error`, so it was not covered by the transport-error rescue.
- `Api::Acsrf#gen_form` sends `hrefId`, the parameter ZAP requires; it sent
  `hid`, so every call failed with `missing_parameter`. It also gained the
  optional `action_url`.
- `Api::Exim#export_site_messages_har` filters on `baseurl`. It sent `url`,
  which ZAP ignores, so it exported every message rather than the site's. It
  also gained `start`/`count`.
- `Api::Hud` actions and views send the parameters ZAP marks mandatory
  (`record`, `header`/`body`, the `String`/`Boolean` option values, `key`,
  `url`); previously all fifteen sent none and always failed. **Breaking**:
  they take arguments.
- `Api::Pscan#set_option_max_alerts_per_rule` / `#set_option_scan_only_in_scope`
  / `#option_max_alerts_per_rule` / `#option_scan_only_in_scope` and
  `Api::Reveal#reveal_hidden_fields?` / `#set_reveal_hidden_fields` target the
  endpoints ZAP actually exposes (`setMaxAlertsPerRule`, `setScanOnlyInScope`,
  `reveal`, `setReveal`, …); the `setOption*` / `option*` names they used do
  not exist and failed with `bad_action` / `bad_view`.
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
  ajax spider status no longer raises `TypeCastError`. A timeout raises
  `Zap::TimeoutError` (a `Zap::Error`, so existing rescues keep working).
- A path prefix in `base_url` (e.g. `https://ci.example/zap`, a
  reverse-proxied daemon) is kept on every request instead of being silently
  dropped, which previously turned every endpoint into an unexplained 404.
- `ZAP_URL` / `ZAP_API_KEY` no longer override values passed explicitly to
  `Client.new`. Both parameters now default to `nil`, so passing a value wins
  even when it equals the built-in default — previously
  `Client.new("http://localhost:8080")` could be redirected by `ZAP_URL`, and
  `Client.new(url, "")` still picked up `ZAP_API_KEY`.
- `Scan#full` / `#spider_and_scan` / `#active` wait for the passive-scan queue
  to drain before reading the alerts summary, reported as a final `"pscan"`
  phase. Passive rules run asynchronously, so the summary previously
  under-reported findings on every run. Opt out with `wait_for_passive: false`.
- `Api::Core#alerts` / `#number_of_alerts` accept `Int32` and `Zap::Risk` for
  `start` / `count` / `risk_id`, matching `Api::Alert` — the enum did not
  compile against `core` before. The previous `String` form still works.

### Added

- `Api::AlertFilter` add/remove gained `parameter_is_regex`, `attack`,
  `attack_is_regex`, `evidence`, `evidence_is_regex` and `methods`, and
  `new_level` accepts a `Zap::Risk`.
- `Api::Alert#alerts` gained the `false_positive` filter.
- `Api::OpenApi` imports gained `user_id`; `Api::Script#load` gained
  `charset`; `Api::Replacer#add_rule` gained `url`/`method`;
  `Api::AjaxSpider#add_excluded_element` gained the xpath/text/attribute
  criteria; `Api::Client` gained the passive-scan options.
- `Api::Postman#import_file` / `#import_url` gained `endpoint_url`.
- `Zap::TimeoutError` and `Zap::Client::DEFAULT_BASE_URL`.

## v0.2.0

- `Api::ClientSpider#scan` now accepts `url`, `browser`, `context_name`, `user_name`,
  `subtree_only`, `max_crawl_depth`, `page_load_time`, `action_wait_time`,
  `number_of_browsers`, `scope_check`, and `logout_avoidance`, and returns the scan id.
- `Api::ClientSpider#stop` and `#status` now accept an optional `scan_id`.
- `Api::Postman#import_file` and `#import_url` now send the required `file`/`url`
  parameters (previously sent no parameters and were non-functional).

## v0.1.0

- Initial release
