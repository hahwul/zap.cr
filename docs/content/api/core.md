+++
title = "Core"
weight = 2
+++

Core ZAP operations: sessions, messages, site tree, and global options.

**Accessor:** `client.core`

## Views

| Method | Description |
|--------|-------------|
| `version` | ZAP version |
| `alerts(base_url, start, count)` | Alerts list |
| `alerts_summary(base_url)` | Alert counts by risk level |
| `number_of_alerts(base_url, risk_id)` | Alert count |
| `message(id)` | Single HTTP message by ID |
| `messages(base_url, start, count)` | HTTP messages list |
| `number_of_messages(base_url)` | Message count |
| `home_directory` | ZAP home directory |
| `child_nodes(url)` | Direct children of a site tree node |
| `excluded_from_proxy` | Proxy exclusion regexes |
| `client.network.root_ca_cert` | Root CA certificate |
| `option_default_user_agent` | Default User-Agent |
| `option_timeout_in_secs` | Request timeout |
| `option_http_state` | HTTP state enabled |
| `option_proxy_chain_name` | Upstream proxy host |
| `option_proxy_chain_port` | Upstream proxy port |
| `option_maximum_alert_instances` | Max alert instances |

## Actions

| Method | Description |
|--------|-------------|
| `new_session(name, overwrite)` | Create new session |
| `save_session(name, overwrite)` | Save current session |
| `snapshot_session(name, overwrite)` | Snapshot session |
| `access_url(url, follow_redirects)` | Access a URL through ZAP |
| `shutdown` | Shutdown ZAP |
| `exclude_from_proxy(regex)` | Exclude from proxy |
| `clear_excluded_from_proxy` | Clear proxy exclusions |
| `generate_root_ca` | Generate new root CA |
| `add_session_token(site, name)` | Add session token |
| `remove_session_token(site, name)` | Remove session token |
| `set_option_default_user_agent(ua)` | Set User-Agent |
| `set_option_timeout_in_secs(timeout)` | Set timeout |
| `set_option_maximum_alert_instances(n)` | Set max alert instances |
| `delete_all_alerts` | Delete all alerts |

ZAP 2.17.0 rejects the legacy `site_tree`, `sessions`,
`session_properties`, `certificate_content`, `option`, and
`delete_session` calls. Use `child_nodes` to browse the tree and the
Network API to read the root CA certificate.

## Examples

```crystal
# Check ZAP version
puts client.core.version

# Create a fresh session
client.core.new_session("test", overwrite: true)

# Browse site tree
tree = client.core.child_nodes
```
