---
name: sdd-hook-create
description: >-
  Use this skill to scaffold lifecycle hook entries in the workspace hooks.json
  file. Guides the user through selecting hook type (PreToolUse, PostToolUse,
  PreInvocation, PostInvocation, SessionStart, Stop), defining tool matchers,
  and writing portable cross-platform hook scripts. Activate when the user wants
  to 'add a hook', 'configure PreToolUse hook', 'create a lifecycle hook', or
  'add a hooks.json entry'.
---

# sdd-hook-create — Scaffold a Lifecycle Hook

## Purpose
Add a new named hook entry to `hooks.json` (or create it if absent) conforming to Antigravity's `map[string]JSONHookSpec` schema, and optionally scaffold the referenced script. Hooks allow Antigravity 2.0 to gate, auto-approve, or audit tool calls and agent turns via a JSON `stdin`/`stdout` contract.

## Prerequisites
- Know the **workspace root path** before beginning.
- Confirm that the target hook name **does not conflict** with an existing top-level hook key in `hooks.json`.

## Step 1 — Gather Hook Configuration

Ask the user (one question at a time if not already provided):

1. **Hook name (kebab-case)**:
   - Unique top-level identifier in `hooks.json` (e.g., `sdd-proposal-guard`, `lint-checker`).

2. **Hook event type**:
   - `PreToolUse` — runs BEFORE a tool is invoked. Outputs `{"decision": "allow" | "deny" | "ask" | "force_ask", "reason": "..."}` on `stdout`.
   - `PostToolUse` — runs AFTER a tool completes. Outputs `{}` on `stdout`.
   - `PreInvocation` — runs before each model call. Outputs `{"injectSteps": [...], "terminationBehavior": ""}` on `stdout`.
   - `PostInvocation` — runs after tool calls finish.
   - `SessionStart` — runs once when a new conversation session starts.
   - `Stop` — runs when the execution loop terminates.

3. **Tool matcher** (required for `PreToolUse` and `PostToolUse` only):
   - `write_to_file|write_file|replace_file_content|edit_file` — file write tools
   - `view_file|read_file|grep_search|find_by_name|list_dir` — read-only tools
   - `run_command` — shell execution tool
   - `*` — all tools

4. **Command / Script path**:
   - Recommend portable Node.js script: `node .agents/hooks/<hook-name>.mjs` (or `.agents/hooks/<hook-name>.sh` on Unix-only environments).
   - Note: Antigravity executes hook commands with `cwd` set to the directory containing `hooks.json` (`cmd /c` on Windows, `sh -c` on Unix).

5. **Create script stub**: Should a script stub be scaffolded at the target path? (yes/no)

## Step 2 — Resolve hooks.json Path

- For workspace-level hooks: `<workspace-root>/.agents/hooks.json` (or `<workspace-root>/hooks.json`).
- For plugin-level hooks: `<plugin-root>/hooks.json`.

Read `hooks.json` if it exists to preserve all existing top-level hook keys.

## Step 3 — Confirm Before Writing

Display:
```text
📋 New Hook — Execution Plan

Hook Name:   <hook-name>
Event:       <event-type>
Matcher:     <tool-matcher>
Command:     <command>

Changes to hooks.json:
  Add top-level key "<hook-name>" with <event-type> handler.

Files to create:
  <script-path>  (stub)   (if requested)

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Update hooks.json

Read `resources/hook-recipe-template.json` for the official `map[string]JSONHookSpec` format.

> [!CAUTION]
> NEVER add `"$schema"` or `"_comment"` keys at the root of `hooks.json`. The Antigravity Go loader unmarshals every top-level key directly into `jsonhook.JSONHookSpec` and will skip the entire file if any top-level value is a string. Use `"enabled": false` inside a named hook object to disable a hook.

For `PreToolUse` or `PostToolUse` (grouped with `matcher` and `hooks` wrapper):
```json
{
  "<hook-name>": {
    "enabled": true,
    "PreToolUse": [
      {
        "matcher": "<tool-matcher>",
        "hooks": [
          {
            "type": "command",
            "command": "<command>",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

For `PreInvocation`, `PostInvocation`, `SessionStart`, or `Stop` (flat handler list):
```json
{
  "<hook-name>": {
    "enabled": true,
    "PreInvocation": [
      {
        "type": "command",
        "command": "<command>",
        "timeout": 10
      }
    ]
  }
}
```

## Step 5 — Scaffold Script Stub (if requested)

Create `.agents/hooks/<hook-name>.mjs` with:
```javascript
#!/usr/bin/env node
import fs from "node:fs";

function main() {
  try {
    const raw = fs.readFileSync(0, "utf8");
    const payload = raw.trim() ? JSON.parse(raw) : {};
    // payload.toolCall = { name, args }, payload.workspacePaths = [...]
    // For PreToolUse: decision can be "allow", "deny", "ask", or "force_ask"
    process.stdout.write(JSON.stringify({ decision: "allow" }) + "\n");
  } catch {
    process.stdout.write("{}\n");
  }
}

main();
```

## Step 6 — Confirm

```text
✅ Hook configured.

hooks.json updated:
  Hook:    <hook-name>
  Event:   <event-type>
  Matcher: <matcher>
  Command: <command>

Portability & Contract Reminders:
  - Hook commands read JSON from stdin and MUST output valid JSON on stdout.
  - Use "node <script>.mjs" for cross-platform compatibility across Windows (cmd /c) and Unix (sh -c).
  - Run "agy plugin validate ." (if inside a plugin) to verify zero schema errors.
```
