# Examples

Runnable examples for `zap.cr`.

Each example assumes a running ZAP instance reachable at `http://localhost:8080`.
Override the host and API key via environment variables:

```sh
export ZAP_URL="http://localhost:8080"
export ZAP_API_KEY="your-api-key"
```

Run an example with:

```sh
crystal run examples/basic.cr
```

| File | Description |
| ---- | ----------- |
| `basic.cr` | Connect to ZAP and print version / mode. |
| `spider_scan.cr` | Run a traditional spider and print discovered URLs. |
| `active_scan.cr` | Run an active scan against a target. |
| `full_scan.cr` | Spider + Ajax Spider + Active Scan with progress callback. |
| `alerts.cr` | Fetch alerts and summarize by risk. |
| `context_scan.cr` | Create a context, set scope, and scan inside it. |
| `report.cr` | Generate a traditional HTML report. |
