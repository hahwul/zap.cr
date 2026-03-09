+++
title = "Script"
weight = 11
+++

Manage and execute ZAP scripts.

**Accessor:** `client.script`

## Views

| Method | Description |
|--------|-------------|
| `list` | All loaded scripts |
| `engines` | Available script engines |
| `types` | Script types |
| `global_var(name)` | Get global variable |
| `global_vars` | All global variables |
| `script_var(script_name, var_name)` | Get script variable |
| `script_vars(script_name)` | All script variables |

## Actions

| Method | Description |
|--------|-------------|
| `load(name, type, engine, file_name, description)` | Load script |
| `remove(name)` | Remove script |
| `run(name)` | Run standalone script |
| `enable(name)` | Enable script |
| `disable(name)` | Disable script |
| `set_global_var(name, value)` | Set global variable |
| `clear_global_var(name)` | Clear global variable |
| `clear_global_vars` | Clear all global variables |
| `set_script_var(script_name, var_name, value)` | Set script variable |
| `clear_script_var(script_name, var_name)` | Clear script variable |
| `clear_script_vars(script_name)` | Clear all script variables |

## Example

```crystal
# Load and run a script
client.script.load("my-script", "standalone", "ECMAScript",
  "/path/to/script.js", "Custom scan script")
client.script.enable("my-script")
client.script.run("my-script")
```
