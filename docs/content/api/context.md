+++
title = "Context"
weight = 8
+++

Define scan scope with URL patterns and technology filters.

**Accessor:** `client.context`

## Views

| Method | Description |
|--------|-------------|
| `context(name)` | Context details |
| `context_list` | All contexts |
| `included_regexs(name)` | Include patterns |
| `excluded_regexs(name)` | Exclude patterns |
| `urls(name)` | URLs in context |
| `technology_list` | Available technologies |
| `included_technology_list(name)` | Included technologies |
| `excluded_technology_list(name)` | Excluded technologies |

## Actions

| Method | Description |
|--------|-------------|
| `new_context(name)` | Create context |
| `remove_context(name)` | Remove context |
| `include_in_context(name, regex)` | Add include pattern |
| `exclude_from_context(name, regex)` | Add exclude pattern |
| `set_context_in_scope(name, in_scope)` | Set scope flag |
| `export_context(name, file_path)` | Export to file |
| `import_context(file_path)` | Import from file |
| `include_context_technologies(name, tech)` | Include technologies |
| `exclude_context_technologies(name, tech)` | Exclude technologies |
| `include_all_contexts_technologies` | Include all tech |
| `exclude_all_contexts_technologies` | Exclude all tech |

## Example

```crystal
ctx = client.context.new_context("my-app")
client.context.include_in_context("my-app", "http://target\\.com.*")
client.context.exclude_from_context("my-app", ".*logout.*")
```
