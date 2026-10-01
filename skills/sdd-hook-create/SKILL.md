---
name: sdd-hook-create
description: >-
  Use this skill to scaffold lifecycle hook entries in the workspace hooks.json
  file. Guides the user through selecting hook type (PreToolUse, PostToolUse,
  PreInvocation, PostInvocation), defining tool matchers, and writing portable
  shell script stubs. Enforces cross-platform portability guidelines. Activate
  when the user wants to 'add a hook', 'configure PreToolUse hook', 'create a
  lifecycle hook', or 'add a hooks.json entry'.
---

# sdd-hook-create — Scaffold a Lifecycle Hook

## Purpose
Add a new hook entry to `hooks.json` (or create it if absent) and optionally scaffold the referenced shell script. Hooks allow Antigravity 2.0 to run external checks before or after specific tool calls.

## Prerequisites
- Know the **workspace root path** before beginning.
- Confirm that the target hook **does not conflict** with an existing hook for the same tool and event.

## Step 1 — Gather Hook Configuration

Ask the user (one question at a time if not already provided):

1. **Hook event type**:
   - `PreToolUse` — runs BEFORE a tool is invoked. Exit 1 to block the tool call.
   - `PostToolUse` — runs AFTER a tool completes. Exit 1 to flag a warning.
   - `PreInvocation` — runs before each agent turn.
   - `PostInvocation` — runs after each agent turn.

2. **Tool matcher**: Which tool(s) should trigger this hook? Examples:
   - `write_to_file` — single tool
   - `write_to_file|replace_file_content` — multiple tools (pipe-separated)
   - `*` — all tools

3. **Script path**: Where should the hook script live? Recommend: `.agents/hooks/<descriptive-name>.sh`

4. **Script purpose**: Brief description of what the script will check/do.

5. **Create script stub**: Should a shell script stub be scaffolded at the script path? (yes/no)

## Step 2 — Resolve hooks.json Path

The hooks.json file lives at the **plugin root** or the **workspace root** depending on context.
For workspace-level hooks: `<workspace-root>/hooks.json`

Read `hooks.json` if it exists to understand the current structure.

## Step 3 — Confirm Before Writing

Display:
```
📋 New Hook — Execution Plan

Event:       <event-type>
Matcher:     <tool-matcher>
Script:      <script-path>

Changes to hooks.json:
  Add entry under "<event-type>": { "matcher": "<matcher>", "command": "<script-path>" }

Files to create:
  <script-path>  (stub)   (if requested)

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Update hooks.json

Read `resources/hook-recipe-template.json` for the entry format.

Add the new hook entry to the appropriate event array in `hooks.json`. If the array does not exist, create it. Preserve all existing entries.

## Step 5 — Scaffold Script Stub (if requested)

Create `.agents/hooks/<script-name>.sh` with:
```bash
#!/bin/sh
# Hook: <event-type> — <tool-matcher>
# Purpose: <user's description>
# Exit 0 to allow the tool call. Exit 1 to block it (PreToolUse only).
# This script receives tool call details via environment variables (check AGY docs).

# TODO: Implement your check logic here.

exit 0
```

Mark the script executable (if on Linux/macOS): note in the confirmation that the user should run `chmod +x <script-path>`.

## Step 6 — Confirm

```
✅ Hook configured.

hooks.json updated:
  Event:   <event-type>
  Matcher: <matcher>
  Script:  <script-path>

Portability reminders:
  - Use /bin/sh (not bash) for maximum portability across Linux, macOS, and WSL.
  - Avoid OS-specific paths. Use relative paths from workspace root.
  - Do NOT hardcode environment-specific values in the script.
  - Test on all target platforms before committing.
  
If you created a script stub, run: chmod +x <script-path>
Then implement the logic inside the script.
```

## Notes
- Hook scripts must be committed alongside `hooks.json` in version control.
- An exit code of 1 in a `PreToolUse` hook blocks the tool call — use this carefully.
- Reference: `.agents/hooks/` is the recommended location for all hook scripts.
