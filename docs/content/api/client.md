+++
title = "Client"
weight = 1
+++

The main entry point for interacting with ZAP.

## Constructor

```crystal
client = Zap::Client.new(base_url : String = "http://localhost:8080", api_key : String = "")
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `base_url` | `String` | `"http://localhost:8080"` | ZAP API base URL |
| `api_key` | `String` | `""` | API key for authentication |

## Properties

```crystal
client.base_url : String   # get/set
client.api_key : String    # get/set
```

## API Module Accessors

| Method | Returns | ZAP Component |
|--------|---------|---------------|
| `client.core` | `Api::Core` | core |
| `client.spider` | `Api::Spider` | spider |
| `client.ajax_spider` | `Api::AjaxSpider` | ajaxSpider |
| `client.ascan` | `Api::Ascan` | ascan |
| `client.pscan` | `Api::Pscan` | pscan |
| `client.alert` | `Api::Alert` | alert |
| `client.alert_filter` | `Api::AlertFilter` | alertFilter |
| `client.context` | `Api::Context` | context |
| `client.authentication` | `Api::Authentication` | authentication |
| `client.authorization` | `Api::Authorization` | authorization |
| `client.forced_user` | `Api::ForcedUser` | forcedUser |
| `client.http_sessions` | `Api::HttpSessions` | httpSessions |
| `client.users` | `Api::Users` | users |
| `client.script` | `Api::Script` | script |
| `client.network` | `Api::Network` | network |
| `client.openapi` | `Api::OpenApi` | openapi |
| `client.graphql` | `Api::Graphql` | graphql |
| `client.soap` | `Api::Soap` | soap |
| `client.exim` | `Api::Exim` | exim |
| `client.reports` | `Api::Reports` | reports |
| `client.search` | `Api::Search` | search |
| `client.stats` | `Api::Stats` | stats |
| `client.session_management` | `Api::SessionManagement` | sessionManagement |
| `client.autoupdate` | `Api::Autoupdate` | autoupdate |
| `client.selenium` | `Api::Selenium` | selenium |
| `client.replacer` | `Api::Replacer` | replacer |
| `client.reveal` | `Api::Reveal` | reveal |
| `client.params` | `Api::Params` | params |
| `client.acsrf` | `Api::Acsrf` | acsrf |
| `client.access_control` | `Api::AccessControl` | accessControl |
| `client.automation` | `Api::Automation` | automation |
| `client.breakpoints` | `Api::Breakpoints` | break |
| `client.websocket` | `Api::Websocket` | websocket |

## Convenience

| Method | Returns | Description |
|--------|---------|-------------|
| `client.scan` | `Zap::Scan` | High-level scanning workflows |

## Low-Level Methods

```crystal
# JSON response
client.request(path : String, params : Hash(String, String) = {}) : JSON::Any

# Raw string response (post: true sends params as a form body)
client.request_other(path : String, params : Hash(String, String) = {}, *, post : Bool = false) : String
```

A non-2xx reply raises `Zap::HttpError`. A failed JSON view or action
answers 400 (500 for `internal_error`) with ZAP's error JSON, so `HttpError#code` and
`#api_message` hold its `code` and `message` (`"does_not_exist"`,
`"Does Not Exist"`); both are nil for any other body. ZAP's core and exim `other`
endpoints report failures as HTTP 200 with an error JSON
(`{"code": ..., "message": ...}`), so `request_other` raises `Zap::ApiError`
for that body; `#code` holds ZAP's error code (`does_not_exist`, ...) and
`#api_message` its message.

These are used internally by all API modules. You can use them for endpoints not yet wrapped:

```crystal
result = client.request("/JSON/core/view/version/")
```
