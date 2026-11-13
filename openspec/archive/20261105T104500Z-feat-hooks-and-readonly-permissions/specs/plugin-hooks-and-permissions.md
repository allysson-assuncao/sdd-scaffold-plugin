---
id: "spec-plugin-hooks-and-permissions"
title: "Plugin Lifecycle Hooks & Read-Only Permission Model"
version: "1.0.0"
status: "draft"
owners:
  - "@allysson-assuncao"
scope:
  paths:
    - "hooks.json"
    - "scripts/**"
    - "agents/sdd-code-explorer.md"
    - "agents/sdd-spec-auditor.md"
    - "skills/sdd-hook-create/**"
resources: []
---

# Plugin Lifecycle Hooks & Read-Only Permission Model — Living Specification

> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from `openspec/changes/`.

---

## Context & Objectives

Defines the lifecycle hook architecture (`hooks.json` and `scripts/*.mjs`) and the read-only subagent permission model for `sdd-scaffold-plugin`. Its primary objective is to eliminate unnecessary interactive permission prompts during safe code-scanning and specification-auditing operations while providing valid, opt-in SDD governance hook recipes that pass `agy plugin validate` across Windows, macOS, and Linux.

## Functional Requirements

- **[RF-01] `hooks.json` Schema Compliance:** The root `hooks.json` file MUST conform to Antigravity's `map[string]JSONHookSpec` schema, where every top-level key is a unique hook identifier containing an optional `enabled` boolean and lifecycle event arrays (`PreToolUse`, `PostToolUse`, `PreInvocation`, `PostInvocation`, `SessionStart`, `Stop`). Top-level metadata strings (`$schema`, `_comment`) are forbidden.
- **[RF-02] Active Read-Only Auto-Allow Hook (`sdd-readonly-auto-allow`):** The plugin MUST ship an enabled `PreToolUse` hook (`sdd-readonly-auto-allow`) matching `view_file|read_file|grep_search|find_by_name|list_dir|run_command` backed by `node scripts/sdd-readonly-guard.mjs`.
- **[RF-03] Safe Tool & Sensitive-Path Filtering:** `scripts/sdd-readonly-guard.mjs` MUST output `{"decision": "allow"}` for native read/search tools (`view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`) UNLESS the target path matches sensitive credential patterns (`.env`, `.ssh`, `.aws`, `.npmrc`, `.pypirc`, private keys, or credential files), in which case it MUST output `{}` to defer to standard user confirmation.
- **[RF-04] Read-Only Shell Command Filtering:** For `run_command` invocations, `scripts/sdd-readonly-guard.mjs` MUST only output `{"decision": "allow"}` when `CommandLine` matches an explicit allowlist of non-destructive inspection commands (`git status`, `git log`, `git diff`, `git show`, `git branch`, `agy plugin validate`, `Get-ChildItem`, `Select-String`, `Test-Path`, `ls`, `pwd`, `wc`) and contains no shell redirection, command substitution, or command chaining operators (`>`, `<`, `|`, `;`, `&`, `$()`, backticks).
- **[RF-05] Opt-In SDD Governance Hook Recipes:** `hooks.json` MUST include `sdd-enforce-proposal`, `sdd-scope-prompt-writes`, and `sdd-run-linter` configured with `"enabled": false` and backed by existing scripts in `scripts/` so users can enable them without triggering missing-script warnings during `agy plugin validate`.
- **[RF-06] Read-Only Subagent Tool Completeness:** `agents/sdd-code-explorer.md` and `agents/sdd-spec-auditor.md` MUST explicitly declare `view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`, and `send_message` in their `tools:` YAML frontmatter, while omitting all file-mutation and shell-execution tools.

## Non-Functional Requirements

- **[RNF-01] Cross-Platform Portability:** All plugin hook commands MUST execute identically under both Windows (`cmd /c`) and Unix (`sh -c`) using zero-dependency Node.js standard library scripts (`node scripts/*.mjs`).
- **[RNF-02] Fail-Open Resilience:** Hook scripts MUST trap all unexpected JSON parsing or runtime errors and exit `0` with `{}` on `stdout` so malformed input never deadlocks the agent execution loop.

## Out of Scope

- Modifying host-level Antigravity global configuration files (`settings.json`) outside the plugin boundary.
- Executing network calls or installing third-party npm packages inside `scripts/`.

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-11-05 | @allysson-assuncao | Initial specification for `feat-hooks-and-readonly-permissions` |
