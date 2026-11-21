+++
title = "Search"
weight = 9
+++

Search captured HTTP traffic by URL, request, response, header, tag, or note patterns.

**Accessor:** `client.search`

## Message Search

All methods accept: `regex`, `base_url` (optional), `start` (optional), `count` (optional).

ZAP matches `base_url` as a literal prefix. Use a slash after the host for
origin-scoped searches, for example `http://target.com/`. Both `start: 0`
and `start: 1` select the first record. ZAP can return the same message
twice in header searches when both the request and response headers match.

| Method | Searches |
|--------|----------|
| `messages_by_url_regex(regex, ...)` | URL |
| `messages_by_request_regex(regex, ...)` | Request headers and body |
| `messages_by_response_regex(regex, ...)` | Response headers and body |
| `messages_by_header_regex(regex, ...)` | Headers |
| `messages_by_tag_regex(regex, ...)` | Tags |
| `messages_by_note_regex(regex, ...)` | Notes |

## URL Search

| Method | Searches |
|--------|----------|
| `urls_by_url_regex(regex, ...)` | URL |
| `urls_by_request_regex(regex, ...)` | Request headers and body |
| `urls_by_response_regex(regex, ...)` | Response headers and body |
| `urls_by_header_regex(regex, ...)` | Headers |
| `urls_by_tag_regex(regex, ...)` | Tags |
| `urls_by_note_regex(regex, ...)` | Notes |

## HAR Export

Returns raw HAR (HTTP Archive) string.

| Method | Searches |
|--------|----------|
| `har_by_url_regex(regex, ...)` | URL |
| `har_by_request_regex(regex, ...)` | Request headers and body |
| `har_by_response_regex(regex, ...)` | Response headers and body |
| `har_by_header_regex(regex, ...)` | Headers |
| `har_by_tag_regex(regex, ...)` | Tags |
| `har_by_note_regex(regex, ...)` | Notes |

## Example

```crystal
# Find all URLs containing "api"
results = client.search.urls_by_url_regex(".*api.*")

# Find responses containing passwords
messages = client.search.messages_by_response_regex("password")

# Export matching traffic as HAR
har = client.search.har_by_url_regex(".*target\\.com.*")
```
