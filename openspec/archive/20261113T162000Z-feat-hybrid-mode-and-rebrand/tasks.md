# Tasks: Hybrid Mode Governance and Plugin Rebrand

> **Change ID:** `feat-hybrid-mode-and-rebrand`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** completed
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [x] **T-01:** Update `plugin.json` to set `"name": "agentic-dev-workflow"`, `"version": "4.0.0"`, and updated hybrid-workflow `"description"`.
- [x] **T-02:** Refactor `rules/AGENTS.md` to implement Dual-Mode Governance (Strict SDD when `openspec/` exists vs. Adaptive SDD-Suggested with explicit user opt-out when `openspec/` is absent) while keeping mandatory `sdd-code-explorer` delegation and staying `<= 55` lines.
- [x] **T-03:** Update `scripts/check-approved-proposal.mjs` to check whether `openspec/` exists in `workspaceRoot` and fail open (`{}`) when `openspec/` is absent.
- [x] **T-04:** Update plugin name header comments in `scripts/sdd-readonly-guard.mjs`, `scripts/check-approved-proposal.mjs`, `scripts/scope-prompt-writes.mjs`, and `scripts/run-linter.mjs` to `agentic-dev-workflow`.

## Security Validation Tasks

- [x] **T-05:** Verify path normalization and workspace boundary checks in `scripts/check-approved-proposal.mjs` prevent `../` path traversal and fail open safely on malformed JSON input.
- [x] **T-06:** Confirm no secrets, tokens, or credentials are hardcoded across modified scripts and documentation.

## Test Tasks

- [x] **T-07:** Update `validate-v3.sh` to assert `"name": "agentic-dev-workflow"` in `plugin.json`, verify `README.md` exists, and test `scripts/check-approved-proposal.mjs` pass-through in non-SDD workspaces alongside denial in unapproved SDD workspaces.
- [x] **T-08:** Execute `bash validate-v3.sh` and `agy plugin validate .` to verify all unit and integration checks pass.

## Documentation Tasks

- [x] **T-09:** Create root `README.md` documenting `agentic-dev-workflow` v4.0.0, Dual-Mode Governance, skill/subagent/hook catalogs, and global installation/upgrade steps.

## Review Gate

- [x] All implementation tasks complete
- [x] All security validation tasks complete
- [x] All tests passing (`bash validate-v3.sh` and `agy plugin validate .`)
- [x] Proposal acceptance criteria verified (run `sdd-spec-validate`)
- [x] Ready for `sdd-spec-archive`
