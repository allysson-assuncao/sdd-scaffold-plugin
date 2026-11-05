# Tasks: Feat Hooks And Readonly Permissions

> **Change ID:** `feat-hooks-and-readonly-permissions`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** completed
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [x] **T-01:** Update `agents/sdd-code-explorer.md` and `agents/sdd-spec-auditor.md` frontmatter `tools:` to include `view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`, and `send_message`.
- [x] **T-02:** Update `agents/sdd-prompt-architect.md` frontmatter `tools:` to include `view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`, `write_to_file`, `write_file`, `invoke_subagent`, and `send_message`.
- [x] **T-03:** Create `scripts/sdd-readonly-guard.mjs` implementing the `PreToolUse` auto-allow guard (`{"decision": "allow"}`) for read/search tools (with sensitive-file denylist protection) and strictly read-only `run_command` invocations.
- [x] **T-04:** Create the three SDD recipe scripts in `scripts/` (`scripts/check-approved-proposal.mjs`, `scripts/scope-prompt-writes.mjs`, and `scripts/run-linter.mjs`) adhering to the Antigravity `stdin`/`stdout` JSON contract.
- [x] **T-05:** Update root `hooks.json` to the valid `map[string]JSONHookSpec` format with `sdd-readonly-auto-allow` (`"enabled": true`) and the 3 SDD governance recipes (`sdd-enforce-proposal`, `sdd-scope-prompt-writes`, `sdd-run-linter` with `"enabled": false`).
- [x] **T-06:** Update `skills/sdd-hook-create/SKILL.md` and `skills/sdd-hook-create/resources/hook-recipe-template.json` to document the official Antigravity `hooks.json` schema and `stdin`/`stdout` JSON decision contract.

## Test Tasks

- [x] **T-07:** Update `validate-v3.sh` with automated checks for `hooks.json` schema validity, `scripts/*.mjs` existence, functional `stdin`/`stdout` tests of `scripts/sdd-readonly-guard.mjs` (happy path + security denylist edge cases), and subagent `tools:` verification.
- [x] **T-08:** Run `bash validate-v3.sh`, `agy plugin validate .`, and `agy plugin install .` to verify zero errors, zero warnings, and clean global installation.

## Documentation Tasks

- [x] **T-09:** Verify that `openspec/changes/feat-hooks-and-readonly-permissions/specs/agent-sdd-prompt-architect-delta.md` and `openspec/changes/feat-hooks-and-readonly-permissions/specs/plugin-hooks-and-permissions.md` accurately reflect all implemented contracts.

## Review Gate

- [x] All implementation tasks complete
- [x] All tests passing
- [x] Proposal acceptance criteria verified
- [x] Ready for `sdd-spec-archive`
