# Proposal: Feat Hooks And Readonly Permissions

> **Change ID:** `feat-hooks-and-readonly-permissions`
> **Status:** approved
> **Author:** @allysson-assuncao
> **Created:** 2026-11-05
> **Last Updated:** 2026-11-05

---

## Summary

Implement a valid, cross-platform `PreToolUse` lifecycle hook architecture in `sdd-scaffold-plugin` that automatically approves safe read-only and code-search operations (`view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`, and non-destructive inspection `run_command` calls), restores the three SDD governance hook recipes (`sdd-enforce-proposal`, `sdd-scope-prompt-writes`, `sdd-run-linter`) using Antigravity's official `"enabled": false` specification and portable Node.js scripts in `scripts/`, completes the `tools:` allowlist in all three plugin subagents (`sdd-code-explorer`, `sdd-spec-auditor`, `sdd-prompt-architect`), and updates `sdd-hook-create` and `validate-v3.sh` to enforce the `map[string]JSONHookSpec` contract.

## Motivation

1. **Eliminating Unnecessary Permission Friction for Read/Search Tasks:** In Antigravity 2.0 (v2.17+), search and directory-listing tools (`grep_search`, `find_by_name`, `list_dir`) were removed from the implicit default baseline and must be explicitly declared in subagent frontmatter (`tools:`). Furthermore, reading plugin templates outside the project workspace (`Non-Workspace File Access`) or executing read-only diagnostic commands triggers interactive permission prompts (`ask`), interrupting autonomous subagents like `sdd-code-explorer` and `sdd-spec-auditor`.
2. **Restoring SDD Hook Recipes Without Breaking `agy plugin validate`:** Previously, `hooks.json` used non-standard keys (`$schema`, `_comment`, `_disabled_matcher`) at the top level and referenced `.agents/hooks/*.sh` scripts that did not exist in the plugin root. This caused `agy plugin install` to register 4 bogus hooks and `agy plugin validate` to fail with a Go `jsonhook.JSONHookSpec` unmarshaling error. Replacing `hooks.json` with `{}` fixed the crash but discarded the 3 SDD lifecycle recipes.
3. **Aligning `sdd-hook-create` with Antigravity's Actual Contract:** The `sdd-hook-create` skill and its `hook-recipe-template.json` still documented an outdated schema instead of Antigravity's `map[string]JSONHookSpec` format and JSON `stdin`/`stdout` (`{"decision": "allow" | "deny" | "ask" | "force_ask"}`) contract.

## Scope

### In Scope
- Update `agents/sdd-code-explorer.md`, `agents/sdd-spec-auditor.md`, and `agents/sdd-prompt-architect.md` YAML frontmatter `tools:` lists to include `read_file`, `list_dir`, and `send_message` (plus `write_file` for `sdd-prompt-architect`).
- Create portable Node.js hook scripts under `scripts/`:
  - `scripts/sdd-readonly-guard.mjs`: Active `PreToolUse` handler that auto-approves (`{"decision": "allow"}`) safe read-only tool calls (`view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`) excluding sensitive credential paths, as well as strictly read-only `run_command` inspection commands.
  - `scripts/check-approved-proposal.mjs`: Recipe script for `sdd-enforce-proposal` that checks `workspacePaths[0]/openspec/changes/*/proposal.md` for `Status: approved`.
  - `scripts/scope-prompt-writes.mjs`: Recipe script for `sdd-scope-prompt-writes` that scopes `prompt-*.md` writes when triggered in prompt-architect context.
  - `scripts/run-linter.mjs`: Recipe script stub for `sdd-run-linter` (`PostToolUse`).
- Update root `hooks.json` to conform strictly to `map[string]JSONHookSpec`, enabling `sdd-readonly-auto-allow` (`"enabled": true`) and shipping `sdd-enforce-proposal`, `sdd-scope-prompt-writes`, and `sdd-run-linter` as official disabled recipes (`"enabled": false`).
- Update `skills/sdd-hook-create/SKILL.md` and `skills/sdd-hook-create/resources/hook-recipe-template.json` to reflect Antigravity's true `hooks.json` schema and `stdin`/`stdout` JSON contract.
- Extend `validate-v3.sh` to validate the `hooks.json` schema, script existence in `scripts/`, and subagent tool completeness.

### Out of Scope
- Modifying global user settings outside the plugin directory (`~/.gemini/antigravity-cli/settings.json`), except reinstalling the plugin via `agy plugin install .`.
- Adding external npm dependencies (all scripts in `scripts/` must use Node.js built-in standard library modules only: `node:fs`, `node:path`, `node:process`).

## Proposed Solution

### Approach
First, we update the YAML frontmatter of `agents/sdd-code-explorer.md`, `agents/sdd-spec-auditor.md`, and `agents/sdd-prompt-architect.md` so each subagent explicitly declares all required read/search tools (`view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`) and `send_message`. This guarantees that read-only subagents never fall back to shell execution and can always communicate results back to the parent agent.

Second, we create a `scripts/` directory at the plugin root containing zero-dependency ES module scripts (`.mjs`) invoked via `node scripts/<name>.mjs`. Using `node` guarantees identical behavior on both Windows (`cmd /c`) and Unix (`sh -c`) when Antigravity executes hook commands with `cwd` set to the plugin root. The active hook `sdd-readonly-auto-allow` in `hooks.json` matches `view_file|read_file|grep_search|find_by_name|list_dir|run_command` and runs `node scripts/sdd-readonly-guard.mjs`. When invoked, it parses the `stdin` JSON payload, verifies that file targets do not touch sensitive secret files (`.env`, `.ssh`, `.aws`, private keys), and outputs `{"decision": "allow"}` for native read/search tools and whitelisted read-only shell commands (`git status`, `git log`, `git diff`, `git show`, `git branch`, `agy plugin validate`, `Get-ChildItem`, `Select-String`, `Test-Path`, `ls`, `pwd`, `wc`).

Third, we restore the three governance hooks (`sdd-enforce-proposal`, `sdd-scope-prompt-writes`, and `sdd-run-linter`) in `hooks.json` with `"enabled": false` and backing scripts in `scripts/`. Because the scripts exist in the plugin folder and the JSON structure adheres to `map[string]JSONHookSpec`, `agy plugin validate .` passes with 0 errors and 0 warnings. Finally, we update `skills/sdd-hook-create/SKILL.md`, `skills/sdd-hook-create/resources/hook-recipe-template.json`, and `validate-v3.sh`.

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `hooks.json` | Modify | Configure active `sdd-readonly-auto-allow` hook and 3 disabled recipe hooks (`"enabled": false`) conforming to `map[string]JSONHookSpec`. |
| `scripts/sdd-readonly-guard.mjs` | Create | Cross-platform `PreToolUse` script that outputs `{"decision": "allow"}` for safe read/search tools and read-only `run_command` calls. |
| `scripts/check-approved-proposal.mjs` | Create | Cross-platform `PreToolUse` recipe script that blocks write tools unless an approved proposal exists in `openspec/changes/`. |
| `scripts/scope-prompt-writes.mjs` | Create | Cross-platform `PreToolUse` recipe script that restricts prompt-architect file writes to root `prompt-*.md`. |
| `scripts/run-linter.mjs` | Create | Cross-platform `PostToolUse` recipe script stub for running workspace linters after file writes. |
| `agents/sdd-code-explorer.md` | Modify | Add `read_file`, `list_dir`, and `send_message` to `tools:` frontmatter. |
| `agents/sdd-spec-auditor.md` | Modify | Add `read_file`, `list_dir`, and `send_message` to `tools:` frontmatter. |
| `agents/sdd-prompt-architect.md` | Modify | Add `read_file`, `list_dir`, `write_file`, and `send_message` to `tools:` frontmatter. |
| `skills/sdd-hook-create/SKILL.md` | Modify | Align instructions and examples with Antigravity's `map[string]JSONHookSpec` schema and `stdin`/`stdout` JSON contract. |
| `skills/sdd-hook-create/resources/hook-recipe-template.json` | Modify | Update recipe template to valid Antigravity named-hook JSON structure. |
| `validate-v3.sh` | Modify | Add validation checks for `hooks.json` schema compliance, `scripts/*.mjs` existence/execution, and subagent `tools:` entries. |

### Data Model Changes (if applicable)
- `hooks.json` transitions from an empty object `{}` to a typed `map[string]JSONHookSpec` dictionary where each top-level key is a hook identifier containing `enabled` (`boolean`) and event arrays (`PreToolUse`, `PostToolUse`) with `{ matcher, hooks: [{ type: "command", command, timeout }] }`.

## Acceptance Criteria

- [x] **Given** the updated `hooks.json` and `scripts/*.mjs` in the plugin root, **When** `agy plugin validate .` is executed, **Then** validation succeeds with exit code `0`, `0 errors`, `0 warnings`, and reports `hooks 4`.
- [x] **Given** a `PreToolUse` JSON payload on `stdin` for `view_file`, `read_file`, `grep_search`, `find_by_name`, or `list_dir` targeting a workspace or plugin file, **When** `node scripts/sdd-readonly-guard.mjs` runs, **Then** it exits `0` and prints `{"decision":"allow",...}` to `stdout`.
- [x] **Given** a `PreToolUse` JSON payload on `stdin` for `view_file` or `read_file` targeting a sensitive path (e.g., `.env`, `~/.ssh/id_rsa`, `.aws/credentials`), **When** `node scripts/sdd-readonly-guard.mjs` runs, **Then** it does NOT auto-approve (outputs `{}` so Antigravity's default security/permission prompt handles it).
- [x] **Given** a `PreToolUse` JSON payload on `stdin` for `run_command` with a safe read-only command (e.g., `git status` or `Get-ChildItem -Path .`) versus a mutating command (e.g., `rm -rf build` or `git commit -m "msg"`), **When** `node scripts/sdd-readonly-guard.mjs` runs, **Then** it outputs `{"decision":"allow",...}` for the safe command and `{}` for the mutating command.
- [x] **Given** the updated subagents `sdd-code-explorer.md`, `sdd-spec-auditor.md`, and `sdd-prompt-architect.md`, **When** `bash validate-v3.sh` is executed, **Then** all acceptance checks pass with `0` failures.

## Defensive Security & Validation Considerations

### Input Validation
- All hook scripts in `scripts/*.mjs` parse `stdin` inside a `try/catch` block, validate field types (`typeof payload?.toolCall?.name === "string"`), normalize file paths, and reject shell metacharacters, command substitution (`$(...)`, backticks), output redirection (`>`, `>>`), pipes to mutating binaries, or chained destructive commands (`;`, `&&`, `||`) before issuing `"decision": "allow"` for `run_command`.

### Secret Isolation
- No secrets, tokens, or environment credentials are read, logged, or stored by any hook script.
- `scripts/sdd-readonly-guard.mjs` explicitly checks target file paths against a sensitive-file denylist pattern (`.env`, `.env.*`, `.ssh/`, `.aws/`, `.npmrc`, `.pypirc`, `id_rsa`, `id_ed25519`, `credentials.json`, `secrets.json`) and refuses to auto-allow read access to matching paths.

### Authorization & Authentication Impact
- Modify access control at the tool-execution hook boundary: only non-destructive read/search operations are auto-approved (`"decision": "allow"`). All file-mutation and arbitrary command execution tools remain subject to normal user approval and sandbox boundaries.

### Other Security Risks
- **Path Traversal & Command Injection Prevention:** Hook scripts never interpolate untrusted input into shell subcommands (`child_process.exec` is not used in `sdd-readonly-guard.mjs`). If `stdin` is malformed or empty, scripts fail safely by returning `{}` with exit code `0`.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `agy plugin validate .` on the repository root | Integration / CLI | Exits `0` with `✔ Validation passed` (0 errors, 0 warnings, 4 hooks recognized). |
| TP-02 | Pipe `PreToolUse` JSON for `view_file` / `grep_search` / `list_dir` into `node scripts/sdd-readonly-guard.mjs` | Unit / Script | Outputs valid JSON with `"decision": "allow"`. |
| TP-03 | Pipe `PreToolUse` JSON for `run_command` (`git status`) into `node scripts/sdd-readonly-guard.mjs` | Unit / Script | Outputs valid JSON with `"decision": "allow"`. |
| TP-04 | Run `agy plugin install .` and `bash validate-v3.sh` | Acceptance | Plugin installs cleanly and all `validate-v3.sh` checks pass. |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Pipe `PreToolUse` JSON for `read_file` targeting `/project/.env` or `~/.ssh/id_rsa` into `node scripts/sdd-readonly-guard.mjs` | Security / Unit | Outputs `{}` (does NOT return `"decision": "allow"`). |
| TE-02 | Pipe `PreToolUse` JSON for `run_command` with chained mutation (`git status && rm -rf /`) into `node scripts/sdd-readonly-guard.mjs` | Security / Unit | Outputs `{}` (does NOT return `"decision": "allow"`). |
| TE-03 | Pipe malformed/invalid JSON into `node scripts/sdd-readonly-guard.mjs` | Resilience / Unit | Exits `0` and outputs `{}` without crashing the hook runner. |
| TE-04 | Test `scripts/check-approved-proposal.mjs` against a workspace with no approved proposal | Unit / Script | Outputs `{"decision": "deny", ...}` blocking the write tool call. |

### Test Commands
- **Run validation suite:** `bash validate-v3.sh`
- **Run CLI plugin validator:** `agy plugin validate .`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Hook script fails on Windows vs Unix due to shell differences (`cmd /c` vs `sh -c`) | Med | High | Invoke all hook scripts via `node scripts/<name>.mjs` using standard Node.js ES modules, avoiding `/bin/sh`-only syntax in `hooks.json`. |
| Overly permissive `run_command` regex auto-allows a command with side effects | Low | High | Enforce strict single-command allowlisting and immediately bail out (`{}`) if any redirection (`>`), subshell (`$()`, `` ` ``), or command separator (`;`, `&`, `|`) is present. |
| Hook crashes on unexpected `stdin` format and blocks agent turn | Low | Med | Wrap all hook entrypoints in `try/catch` that prints `{}` and exits `0` on unexpected errors. |

## Specification Changes & Delta Stubs

### `specs/agent-sdd-prompt-architect-delta.md`
- **Target Canonical Spec:** `openspec/specs/agent-sdd-prompt-architect.md`
- **Summary of Updates:** Update the Frontmatter Contract and Operational Requirements sections to include `read_file`, `list_dir`, `write_file`, and `send_message` in the `tools:` allowlist alongside `view_file`, `grep_search`, `find_by_name`, `write_to_file`, and `invoke_subagent`.

### `specs/plugin-hooks-and-permissions.md`
- **Target Canonical Spec:** `New Specification` (`openspec/specs/plugin-hooks-and-permissions.md`)
- **Summary of Updates:** Define the canonical living specification for `sdd-scaffold-plugin`'s `hooks.json` schema (`map[string]JSONHookSpec`), cross-platform hook scripts in `scripts/`, the `sdd-readonly-auto-allow` permission model, and the `tools:` contract for read-only subagents (`sdd-code-explorer`, `sdd-spec-auditor`).

## References

- Antigravity Customization Docs: `builtin/skills/agy-customizations/docs/hooks.md` & `docs/plugins.md`
- Archived Change: `openspec/archive/20261007T153639Z-feat-sdd-prompt-architect/walkthrough.md`
