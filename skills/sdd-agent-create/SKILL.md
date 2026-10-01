---
name: sdd-agent-create
description: >-
  Use this skill to scaffold a new Antigravity 2.0 subagent with correct YAML
  frontmatter, appropriate tool restrictions, and a clear responsibility scope.
  Enforces best practices: model selection, sandbox policy, least-privilege tools,
  and single responsibility. Activate when the user wants to 'create a subagent',
  'add a specialized agent', 'scaffold a subagent', or 'create a new agent'.
---

# sdd-agent-create — Scaffold a New Subagent

## Purpose
Create a well-formed Antigravity 2.0 subagent file with valid YAML frontmatter (`subagent: true`, `mainAgent: false`) and a focused responsibility scope.

## Step 1 — Gather Subagent Metadata

Ask the user (one question at a time if not already provided):

1. **Subagent name**: Must be kebab-case (e.g., `code-reviewer`, `test-runner`). Must start with a letter.
2. **Short description**: 1–3 sentences in third person. Describe the subagent's role and when the parent agent should invoke it.
3. **Tool set**: Select from available tools. For a read-only subagent (recommended for scanners/auditors): `view_file`, `grep_search`, `find_by_name`. For write-capable subagents: add `write_to_file`, `replace_file_content`. For command-running subagents: add `run_command`.
4. **Model**: `flash` (lightweight, recommended for read-only tasks), `pro` (complex reasoning tasks).
5. **Command execution policy**: `sandbox` (no shell commands, recommended) or `default`.
6. **Target location**: `workspace` (`.agents/agents/<name>.md`) or `global` (`~/.gemini/config/agents/<name>.md`).

## Step 2 — Resolve and Validate Target Path

Construct the target path:
- **workspace**: `<workspace-root>/.agents/agents/<name>.md`
- **global**: `<actual-home-dir>/.gemini/config/agents/<name>.md`

Check that the file does NOT already exist. If it does:
```
❌ STOP: A subagent named `<name>` already exists at `<path>`.
   Choose a different name or edit the existing subagent directly.
```

## Step 3 — Confirm Before Creating

Display:
```
📋 New Subagent — Execution Plan

Name:       <name>
Location:   <full-path>
Model:      <model>
Tools:      <comma-separated list>
Sandbox:    <yes/no>

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Scaffold the Subagent

Read `resources/agent-template.md` and substitute:
- `{{AGENT_NAME}}` → the subagent name
- `{{AGENT_DESCRIPTION}}` → the description
- `{{AGENT_TOOLS}}` → the tool list formatted as a YAML sequence (one `  - tool` per line)
- `{{AGENT_MODEL}}` → the selected model
- `{{AGENT_SANDBOX}}` → `sandbox` or `default`

Write the result to the target path.

## Step 5 — Confirm

```
✅ Subagent `<name>` scaffolded at: <target-path>

Best practices reminder:
  1. Keep subagents narrowly scoped — one clear responsibility per subagent.
  2. Use `model: flash` for read-only or lightweight tasks to reduce cost.
  3. Set `commandExecutionPolicy: sandbox` if the subagent must not run shell commands.
  4. Always set `subagent: true` and `mainAgent: false` in the frontmatter.
  5. Never give a subagent more tools than it needs (principle of least privilege).

Next step: Open <target-path> and fill in the subagent's instructions body.
```

## Notes
- Subagents placed in `.agents/agents/` are auto-discovered by Antigravity 2.0.
- Do NOT register the subagent in `plugin.json` — discovery is automatic.
