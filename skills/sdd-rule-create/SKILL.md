---
name: sdd-rule-create
description: >-
  Use this skill to scaffold a new Antigravity 2.0 behavioral Rule (AGENTS.md)
  for a workspace or global configuration. Rules are always-on directives loaded
  into every agent session. Guides scope selection, checks for existing rules, and
  warns about the 50-line / 20,000-token global budget. Activate when the user
  wants to 'create a rule', 'add a behavioral rule', 'write an AGENTS.md', or
  'add a directory rule'.
---

# sdd-rule-create — Scaffold a New Rule

## Purpose
Create a well-formed Antigravity 2.0 `AGENTS.md` rule file that follows official conventions: plain Markdown (no frontmatter), correct placement, and conciseness.

## Step 1 — Gather Rule Metadata

Ask the user (one question at a time if not already provided):

1. **Rule scope**:
   - `workspace-global` — `<workspace-root>/.agents/rules/AGENTS.md` (applies to all files in the workspace)
   - `directory` — `AGENTS.md` inside a specific directory path (applies only within that directory)
   - `global` — `<actual-home-dir>/.gemini/config/rules/AGENTS.md` (applies to all workspaces on this machine)
2. If `directory` scope: **Which directory?** (full path)
3. **Rule content summary**: What behavior should this rule enforce? (free-form description)

## Step 2 — Resolve and Validate Target Path

Construct the target path:
- `workspace-global`: `<workspace-root>/.agents/rules/AGENTS.md`
- `directory`: `<provided-directory>/AGENTS.md`
- `global`: `<actual-home-dir>/.gemini/config/rules/AGENTS.md`

Check if `AGENTS.md` already exists at the target path:
- If **yes**: Warn the user:
  ```
  ⚠️ An AGENTS.md already exists at <path>.
  Options: (a) append new rule section  (b) view existing content first  (c) cancel
  ```
  Wait for user decision before proceeding.
- If **no**: proceed.

## Step 3 — Confirm Before Creating

Display:
```
📋 New Rule — Execution Plan

Target:   <full-path>
Action:   Create new file / Append to existing

Rule summary: <user's description>

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Create or Append the Rule

Read `resources/rule-template.md` and substitute:
- `{{RULE_TITLE}}` → a concise title for the rule section (derived from the user's description)
- `{{RULE_CONTENT}}` → the rule directives drafted from the user's description

If **creating a new file**: write the full template content.
If **appending**: append the new `## <Rule Title>` section to the existing file.

## Step 5 — Confirm

```
✅ Rule created/updated at: <target-path>

Reminder:
  - Rules are always-on: they are loaded into every agent session automatically.
  - Keep rules concise (ideally under 50 lines total per file).
  - The global rules budget is ~20,000 tokens across all loaded rules.
  - Verbose rules consume this budget and reduce available context for tasks.

Next step: Open <target-path> and review/refine the rule content.
```

## Notes
- Rules do NOT use YAML frontmatter. Write plain Markdown only.
- Do NOT place business specs or implementation details in rules.
