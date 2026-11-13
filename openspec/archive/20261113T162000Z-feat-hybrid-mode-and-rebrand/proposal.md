# Proposal: Hybrid Mode Governance and Plugin Rebrand

> **Change ID:** `feat-hybrid-mode-and-rebrand`
> **Status:** approved
> **Author:** @allysson-assuncao
> **Created:** 2026-11-13
> **Last Updated:** 2026-11-13

---

## Summary

Refactor the plugin into `agentic-dev-workflow` (v4.0.0) and evolve its global governance rules and lifecycle hooks from an unconditional SDD-only lock into an adaptive **Dual-Mode (Strict SDD vs. Non-SDD Opt-Out)** model. When `openspec/` is present in a workspace, the plugin preserves the strict Spec-First Mandate; when `openspec/` is absent (simple or legacy repositories), the agent recommends SDD for structural changes but respects explicit user opt-out to proceed with direct implementation or lightweight decision reports without blocking file mutations. Additionally, create a comprehensive `README.md` and update the acceptance validation suite (`validate-v3.sh`).

## Motivation

1. **Unconditional Lock in Non-SDD Projects:** Currently, `rules/AGENTS.md` imposes an unconditional prohibition on file mutations unless an approved `proposal.md` exists in `openspec/changes/`, stating that this rule cannot be waived by the user. In legacy or lightweight projects that do not use SDD, this creates an instruction conflict when the user explicitly requests a direct workflow.
2. **Hook Denial When `openspec/` Is Absent:** In `scripts/check-approved-proposal.mjs`, `hasApprovedProposal()` returns `false` whenever `openspec/changes/` does not exist, causing `main()` to return `{"decision": "deny"}` if the `sdd-enforce-proposal` hook is enabled globally.
3. **Broader Plugin Identity & Missing Documentation:** With the addition of SDD-agnostic discovery and technology research workflows alongside the existing 12 `sdd-*` skills, the name `sdd-scaffold-plugin` is overly narrow, and the repository currently lacks a root `README.md` explaining installation, dual-mode governance, and the skill/subagent catalog.

## Scope

### In Scope
- Update `plugin.json` `name` to `"agentic-dev-workflow"`, bump `version` to `"4.0.0"`, and update `description` to reflect dual-mode governance and end-to-end agentic development workflows.
- Refactor `rules/AGENTS.md` (strictly keeping `<= 55` lines and required validation tokens `write_to_file`, `sdd-code-explorer`, and `context bloat`) to define Dual-Mode Governance:
  - **Strict SDD Mode (`openspec/` present):** Unconditional Spec-First Hard Stop before structural code changes.
  - **Adaptive Mode (`openspec/` absent):** Recommend `sdd-init` / spec creation for structural changes, but allow direct execution or lightweight decision reports when the user explicitly declines SDD.
  - **Universal Subagent Delegation:** Keep mandatory `sdd-code-explorer` / `research` delegation in both modes to prevent context bloat.
- Update `scripts/check-approved-proposal.mjs` so that if `openspec/` does not exist at the workspace root, the hook fails open (`{}`) rather than denying writes.
- Update plugin name references in header comments of `scripts/sdd-readonly-guard.mjs`, `scripts/check-approved-proposal.mjs`, `scripts/scope-prompt-writes.mjs`, and `scripts/run-linter.mjs`.
- Create root `README.md` documenting `agentic-dev-workflow` v4.0.0, Dual-Mode Governance, skill/subagent/hook inventory, and `agy plugin validate .` / `agy plugin install .` instructions.
- Update `validate-v3.sh` to verify the new plugin name `agentic-dev-workflow`, `README.md` presence, and dual-mode pass-through behavior in `scripts/check-approved-proposal.mjs`.

### Out of Scope
- Renaming existing `sdd-*` skills (`sdd-init`, `sdd-spec-create`, etc.) or `sdd-*` subagents (`sdd-code-explorer`, `sdd-spec-auditor`, `sdd-prompt-architect`), which retain their identifiers for backward compatibility.
- Creating the new `tech-research` and `discovery-align` skills and `tech-profiler` subagent (covered in the companion change `feat-tech-research-and-discovery`).
- Modifying canonical files under `openspec/specs/` directly before archival via `sdd-spec-archive`.

## Proposed Solution

### Approach
First, `plugin.json` is updated to declare `"name": "agentic-dev-workflow"` and `"version": "4.0.0"`, expanding the description to encompass discovery, technical research, SDD lifecycle management, `.agents/` artifact scaffolding, and prompt engineering across both SDD and non-SDD repositories.

Second, `rules/AGENTS.md` is rewritten concisely within the 55-line budget enforced by `validate-v3.sh`. The rule distinguishes two workspace states under the Spec-First section: (a) if `openspec/` exists in the workspace, the Spec-First Mandate is a strict Hard Stop requiring an approved `proposal.md` and `sdd-spec-validate` audit before structural code changes; (b) if `openspec/` does not exist, the agent recommends initializing SDD or creating a spec for structural changes, but honors an explicit user opt-out to proceed directly without blocking file mutations. Mandatory codebase scanning delegation to `sdd-code-explorer` (and `research`) remains unconditional in both modes.

Third, `scripts/check-approved-proposal.mjs` is updated to check `fs.existsSync(path.join(workspaceRoot, 'openspec'))` before enforcing proposal approval. When `openspec/` does not exist, `check-approved-proposal.mjs` outputs `{}` (pass-through) and exits `0`, ensuring non-SDD workspaces are never locked even when `sdd-enforce-proposal` is enabled in `hooks.json`. Finally, `README.md` is created at the repository root and `validate-v3.sh` is updated to assert the new metadata and hook behavior.

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `plugin.json` | Modify | Rename plugin to `agentic-dev-workflow`, bump version to `4.0.0`, update description |
| `rules/AGENTS.md` | Modify | Introduce Dual-Mode Governance (Strict SDD when `openspec/` exists; opt-out allowed when absent) within `<= 55` lines |
| `scripts/check-approved-proposal.mjs` | Modify | Pass through (`{}`) when `openspec/` directory does not exist in workspace root |
| `scripts/sdd-readonly-guard.mjs` | Modify | Update plugin header comment reference to `agentic-dev-workflow` |
| `scripts/scope-prompt-writes.mjs` | Modify | Update plugin header comment reference to `agentic-dev-workflow` |
| `scripts/run-linter.mjs` | Modify | Update plugin header comment reference to `agentic-dev-workflow` |
| `README.md` | Create | Root documentation for installation, dual-mode governance, skills, subagents, and hooks |
| `validate-v3.sh` | Modify | Update plugin name assertions, `README.md` check, and non-SDD hook pass-through test |

### Data Model Changes (if applicable)
N/A — no database schemas or external API contracts are modified. `plugin.json` and `hooks.json` schemas remain compliant with Antigravity v1 plugin and hook specifications.

## Acceptance Criteria

- [x] **Given** `plugin.json` in the workspace root, **When** `agy plugin validate .` and `bash validate-v3.sh` are executed, **Then** validation passes with plugin name `agentic-dev-workflow` and version `4.0.0`.
- [x] **Given** `rules/AGENTS.md` updated with Dual-Mode Governance, **When** its line count and required tokens are checked by `validate-v3.sh`, **Then** the file has `<= 55` lines and contains `write_to_file`, `sdd-code-explorer`, and `context bloat`.
- [x] **Given** a workspace where `openspec/` exists and has no approved proposal, **When** `node scripts/check-approved-proposal.mjs` receives a `PreToolUse` payload for `src/index.ts`, **Then** it outputs `{"decision": "deny", ...}` blocking the write.
- [x] **Given** a non-SDD workspace where `openspec/` does not exist, **When** `node scripts/check-approved-proposal.mjs` receives a `PreToolUse` payload for `src/index.ts`, **Then** it outputs `{}` (pass-through) allowing the write.
- [x] **Given** a user cloning the repository, **When** they inspect `README.md` at the repository root, **Then** they find complete documentation covering installation (`agy plugin install .`), Dual-Mode Governance (SDD vs. non-SDD), skills, subagents, and hooks.

## Defensive Security & Validation Considerations

### Input Validation
- `scripts/check-approved-proposal.mjs` parses stdin JSON inside a `try/catch` block, validates string types on `workspaceRoot` and target file paths, normalizes paths via `path.resolve()`, and enforces path boundary checks (`normalizedTarget.startsWith(normalizedRoot + path.sep)`) before checking `openspec/` state.

### Secret Isolation
- No credentials, tokens, or API keys are hardcoded in any script, rule, or documentation file. Sensitive-path blocking in `scripts/sdd-readonly-guard.mjs` (`.env`, `.ssh`, `.aws`, `id_rsa`, `credentials.json`, etc.) remains strictly enforced.

### Authorization & Authentication Impact
- N/A — this change operates purely on local Antigravity plugin configuration, Markdown directives, and local stdio hook scripts; it does not expose network endpoints or modify authentication logic.

### Other Security Risks
- **Path Traversal in Hook Payloads:** `scripts/check-approved-proposal.mjs` resolves target paths against `workspaceRoot` before checking `openspec/` or `.agents/` exemptions, preventing `../` traversal from bypassing SDD checks in SDD-enabled workspaces.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `agy plugin validate .` on renamed `agentic-dev-workflow` manifest | Integration | CLI outputs `Validation passed` with 0 errors |
| TP-02 | Run `bash validate-v3.sh` across the repository | Integration | All structural, line-limit, and hook checks pass (`0 failed`) |
| TP-03 | Pipe a `PreToolUse` write payload for a workspace without `openspec/` into `node scripts/check-approved-proposal.mjs` | Unit | Script outputs `{}` and exits with code `0` |
| TP-04 | Pipe a `PreToolUse` write payload for an SDD workspace with an approved `proposal.md` into `node scripts/check-approved-proposal.mjs` | Unit | Script outputs `{}` and exits with code `0` |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Pipe a `PreToolUse` write payload for an SDD workspace (`openspec/changes/` exists, only `draft` proposals) into `node scripts/check-approved-proposal.mjs` | Unit | Script outputs `{"decision":"deny",...}` |
| TE-02 | Pipe malformed JSON into `node scripts/check-approved-proposal.mjs` | Unit | Script fails open with `{}` and exit code `0` without throwing unhandled exceptions |
| TE-03 | Verify `rules/AGENTS.md` line count boundary (`> 55` lines vs `<= 55` lines) | Unit | `validate-v3.sh` passes at `<= 55` lines and fails if exceeded |

### Test Commands
- **Run validation suite:** `bash validate-v3.sh`
- **Plugin schema check:** `agy plugin validate .`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Renaming `plugin.json` creates a second directory under `~/.gemini/config/plugins/` upon `agy plugin install .` | Med | Low | Document removal of old `~/.gemini/config/plugins/sdd-scaffold-plugin` directory in `README.md` upgrade notes |
| Dual-mode wording in `rules/AGENTS.md` exceeds the 55-line budget | Low | Med | Keep `rules/AGENTS.md` compact (~42 lines) and verify via `wc -l` and `validate-v3.sh` |
| Weakening Spec-First inadvertently in workspaces that DO use SDD | Low | High | Condition opt-out strictly on the absence of `openspec/` in the workspace root, both in `rules/AGENTS.md` and `scripts/check-approved-proposal.mjs` |

## Specification Changes & Delta Stubs

### `specs/plugin-hooks-and-permissions-delta.md`
- **Target Canonical Spec:** `openspec/specs/plugin-hooks-and-permissions.md`
- **Summary of Updates:** Update `[RF-05]` (`sdd-enforce-proposal` behavior) so `scripts/check-approved-proposal.mjs` passes through (`{}`) when `openspec/` is absent in the target workspace, and update plugin identifier references to `agentic-dev-workflow`.

### `specs/hybrid-governance-and-identity.md`
- **Target Canonical Spec:** `New Specification` (`openspec/specs/hybrid-governance-and-identity.md`)
- **Summary of Updates:** Define canonical requirements for the `agentic-dev-workflow` v4.0.0 plugin identity, Dual-Mode Governance in `rules/AGENTS.md` (Strict SDD when `openspec/` is present vs. Adaptive Opt-Out when `openspec/` is absent), and root documentation invariants.

## References

- `rules/AGENTS.md`
- `scripts/check-approved-proposal.mjs`
- `openspec/specs/plugin-hooks-and-permissions.md`
- `validate-v3.sh`
