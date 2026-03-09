+++
title = "Network"
weight = 10
+++

Network configuration: proxy, DNS, certificates, rate limiting.

**Accessor:** `client.network`

## Views

| Method | Description |
|--------|-------------|
| `aliases` | Server aliases |
| `local_servers` | Local proxy servers |
| `rate_limit_rules` | Rate limit rules |
| `connection_timeout` | Connection timeout |
| `default_user_agent` | Default User-Agent |
| `dns_ttl_successful_queries` | DNS TTL |
| `http_proxy` | HTTP proxy config |
| `http_proxy_exclusions` | Proxy exclusions |
| `pass_throughs` | Pass-through hosts |
| `socks_proxy` | SOCKS proxy config |

## Actions

| Method | Description |
|--------|-------------|
| `add_alias(name, enabled)` | Add server alias |
| `remove_alias(name)` | Remove alias |
| `set_alias_enabled(name, enabled)` | Toggle alias |
| `add_local_server(address, port, ...)` | Add local server |
| `remove_local_server(address, port)` | Remove local server |
| `set_connection_timeout(timeout)` | Set connection timeout |
| `set_default_user_agent(ua)` | Set User-Agent |
| `set_dns_ttl_successful_queries(ttl)` | Set DNS TTL |
| `set_http_proxy(host, port, ...)` | Configure HTTP proxy |
| `set_http_proxy_enabled(enabled)` | Toggle HTTP proxy |
| `set_http_proxy_auth_enabled(enabled)` | Toggle proxy auth |
| `add_http_proxy_exclusion(host, enabled)` | Add proxy exclusion |
| `remove_http_proxy_exclusion(host)` | Remove exclusion |
| `set_socks_proxy(host, port, ...)` | Configure SOCKS proxy |
| `set_socks_proxy_enabled(enabled)` | Toggle SOCKS proxy |
| `add_pass_through(authority, enabled)` | Add pass-through |
| `remove_pass_through(authority)` | Remove pass-through |
| `generate_root_ca_cert` | Generate root CA |
| `import_root_ca_cert(file_path)` | Import root CA |
| `set_root_ca_cert_validity(days)` | Set CA validity |
| `set_server_cert_validity(days)` | Set server cert validity |

## Example

```crystal
# Route through upstream proxy
client.network.set_http_proxy("proxy.corp.com", 8080)
client.network.set_http_proxy_enabled(true)

# Set SOCKS proxy
client.network.set_socks_proxy("tor.local", 9050, version: 5)
```
