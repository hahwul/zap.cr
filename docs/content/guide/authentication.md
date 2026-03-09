+++
title = "Authentication"
weight = 3
+++

Authenticated scanning requires setting up a context, authentication method, and users.

## Setup Flow

1. Create a context
2. Include target URLs in the context
3. Set authentication method
4. Set logged-in/out indicators
5. Create a user with credentials
6. Scan as that user

## Complete Example

```crystal
# 1. Create context
ctx = client.context.new_context("auth-scan")
ctx_id = ctx["contextId"].as_s.to_i

# 2. Include target in context
client.context.include_in_context("auth-scan", "http://target\\.com.*")

# 3. Set form-based authentication
client.authentication.set_method(
  ctx_id,
  "formBasedAuthentication",
  "loginUrl=http://target.com/login&loginRequestData=username%3D%7B%25username%25%7D%26password%3D%7B%25password%25%7D"
)

# 4. Set indicators
client.authentication.set_logged_in_indicator(ctx_id, "\\QWelcome\\E")
client.authentication.set_logged_out_indicator(ctx_id, "\\QSign in\\E")

# 5. Set session management
client.session_management.set_method(ctx_id, "cookieBasedSessionManagement")

# 6. Create user
user = client.users.new_user(ctx_id, "testuser")
user_id = user["userId"].as_s.to_i
client.users.set_auth_credentials(
  ctx_id, user_id,
  "username=admin&password=secret"
)
client.users.set_enabled(ctx_id, user_id, true)

# 7. Scan as user
client.spider.scan_as_user("auth-scan", "testuser",
  url: "http://target.com"
)
client.ascan.scan_as_user("http://target.com",
  context_id: ctx_id,
  user_id: user_id
)
```

## Authentication Methods

List supported methods:

```crystal
client.authentication.supported_methods
```

Common methods:

| Method | Description |
|--------|-------------|
| `formBasedAuthentication` | HTML form login |
| `httpAuthentication` | HTTP Basic/Digest |
| `jsonBasedAuthentication` | JSON API login |
| `scriptBasedAuthentication` | Custom script |

## Forced User Mode

Force all requests through a specific user:

```crystal
client.forced_user.set(ctx_id, user_id)
client.forced_user.set_enabled(ctx_id, true)

# Check status
client.forced_user.enabled?(ctx_id)
client.forced_user.get(ctx_id)
```
