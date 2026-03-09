+++
title = "Others"
weight = 12
+++

Additional API modules for specialized functionality.

## Authentication (`client.authentication`)

| Method | Description |
|--------|-------------|
| `supported_methods` | List auth methods |
| `get_method(context_id)` | Get auth method for context |
| `get_method_config_params(method_name)` | Config params for method |
| `get_logged_in_indicator(context_id)` | Logged-in regex |
| `get_logged_out_indicator(context_id)` | Logged-out regex |
| `set_method(context_id, method_name, config)` | Set auth method |
| `set_logged_in_indicator(context_id, regex)` | Set logged-in indicator |
| `set_logged_out_indicator(context_id, regex)` | Set logged-out indicator |

## Authorization (`client.authorization`)

| Method | Description |
|--------|-------------|
| `get_method(context_id)` | Get detection method |
| `set_basic_method(context_id, ...)` | Set basic detection |

## Users (`client.users`)

| Method | Description |
|--------|-------------|
| `list(context_id)` | List users |
| `get(context_id, user_id)` | Get user details |
| `new_user(context_id, name)` | Create user |
| `remove_user(context_id, user_id)` | Remove user |
| `set_enabled(context_id, user_id, enabled)` | Enable/disable user |
| `set_name(context_id, user_id, name)` | Rename user |
| `set_auth_credentials(context_id, user_id, config)` | Set credentials |

## Session Management (`client.session_management`)

| Method | Description |
|--------|-------------|
| `supported_methods` | List session methods |
| `get_method(context_id)` | Get session method |
| `set_method(context_id, method_name, config)` | Set session method |

## Forced User (`client.forced_user`)

| Method | Description |
|--------|-------------|
| `get(context_id)` | Get forced user |
| `enabled?(context_id)` | Check if enabled |
| `set(context_id, user_id)` | Set forced user |
| `set_enabled(context_id, enabled)` | Enable/disable |

## HTTP Sessions (`client.http_sessions`)

| Method | Description |
|--------|-------------|
| `sessions(site, session_name)` | List sessions |
| `active_session(site)` | Get active session |
| `session_tokens(site)` | Session tokens |
| `create_empty_session(site, name)` | Create session |
| `remove_session(site, name)` | Remove session |
| `set_active_session(site, name)` | Set active |
| `set_session_token_value(site, session, token, value)` | Set token value |

## Reports (`client.reports`)

| Method | Description |
|--------|-------------|
| `templates` | List report templates |
| `template_details(template)` | Template info |
| `generate(title, template, ...)` | Generate report |

## Exim (`client.exim`)

| Method | Description |
|--------|-------------|
| `import_har(file_path)` | Import HAR file |
| `import_urls(file_path)` | Import URL list |
| `import_mod_security_log(file_path)` | Import ModSecurity logs |
| `import_zap_logs(file_path)` | Import ZAP logs |
| `export_har(base_url, start, count)` | Export as HAR |

## OpenAPI (`client.openapi`)

| Method | Description |
|--------|-------------|
| `import_url(url, host_override, context_id)` | Import from URL |
| `import_file(file, target, context_id)` | Import from file |

## GraphQL (`client.graphql`)

| Method | Description |
|--------|-------------|
| `import_url(url, endpoint)` | Import schema from URL |
| `import_file(file, endpoint)` | Import schema from file |
| `set_option_max_query_depth(depth)` | Max query depth |
| `set_option_request_method(method)` | Request method |
| `set_option_query_gen_enabled(bool)` | Enable query gen |

## SOAP (`client.soap`)

| Method | Description |
|--------|-------------|
| `import_url(url)` | Import WSDL from URL |
| `import_file(file)` | Import WSDL from file |

## Alert Filter (`client.alert_filter`)

| Method | Description |
|--------|-------------|
| `alert_filter_list(context_id)` | Context filters |
| `global_alert_filter_list` | Global filters |
| `add_alert_filter(context_id, rule_id, new_level, ...)` | Add filter |
| `add_global_alert_filter(rule_id, new_level, ...)` | Add global filter |
| `remove_alert_filter(...)` | Remove filter |
| `remove_global_alert_filter(...)` | Remove global filter |
| `apply_all` | Apply all filters |

## Replacer (`client.replacer`)

| Method | Description |
|--------|-------------|
| `rules` | List rules |
| `add_rule(description, enabled, match_type, match_regex, match_string, replacement)` | Add rule |
| `remove_rule(description)` | Remove rule |

## Stats (`client.stats`)

| Method | Description |
|--------|-------------|
| `stats(key_prefix)` | Global stats |
| `all_sites_stats(key_prefix)` | All sites stats |
| `site_stats(site, key_prefix)` | Per-site stats |
| `clear_stats(key_prefix)` | Clear stats |

## Automation (`client.automation`)

| Method | Description |
|--------|-------------|
| `run_plan(file_path)` | Run automation plan |
| `plan_progress(plan_id)` | Plan progress |
| `end_delay_job` | End delay job |

## Other Modules

| Module | Accessor | Key Methods |
|--------|----------|-------------|
| Autoupdate | `client.autoupdate` | `installed_addons`, `install_addon(id)`, `uninstall_addon(id)` |
| Selenium | `client.selenium` | Browser/driver path options |
| Reveal | `client.reveal` | `set_reveal_hidden_fields(bool)` |
| Params | `client.params` | `params(site)` - discovered parameters |
| Acsrf | `client.acsrf` | Anti-CSRF token management |
| Access Control | `client.access_control` | `scan(context_id)`, `write_html_report(...)` |
| Breakpoints | `client.breakpoints` | HTTP breakpoint debugging |
| Websocket | `client.websocket` | `channels`, `messages`, `send_text_message` |
