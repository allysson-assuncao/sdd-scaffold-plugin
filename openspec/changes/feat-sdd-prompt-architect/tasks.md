# Tasks: feat-sdd-prompt-architect

> **Change ID:** `feat-sdd-prompt-architect`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Phase 1 — Skill `sdd-prompt-craft`
- [x] Copy `Universal Prompt Guide & Templates.md` to `skills/sdd-prompt-craft/resources/prompt-guide.md` and append Section 4
- [x] Create `skills/sdd-prompt-craft/SKILL.md` (< 500 lines, correct frontmatter)
- [x] Verification: check line counts and template contents
- [x] Local commit: `feat(skill): add sdd-prompt-craft`

## Phase 2 — Subagent `sdd-prompt-architect`
- [x] Create `agents/sdd-prompt-architect.md` (flash, no run_command, scoped tools)
- [x] Verification: compare frontmatter with `agents/sdd-code-explorer.md`
- [x] Local commit: `feat(agent): add sdd-prompt-architect`

## Phase 3 — Write-Scope Hardening (Hooks)
- [x] Evaluate and configure write-scope PreToolUse hook in `hooks.json`
- [x] Verification: parse `hooks.json` and ensure valid JSON schema
- [x] Local commit: `feat(hooks): scope sdd-prompt-architect writes` (or record limitation)

## Phase 4 — Registration & Validation
- [x] Update `validate-v3.sh` to include `sdd-prompt-craft`, `sdd-prompt-architect`, and resource checks
- [x] Update `plugin.json` description
- [x] Verification: run `validate-v3.sh` and ensure 100% pass rate
- [x] Local commit: `chore: register sdd-prompt-craft and sdd-prompt-architect`
- [x] Final cumulative walkthrough update and user verification readiness

## Review Gate
- [x] All implementation tasks complete
- [x] All tests passing (`validate-v3.sh`)
- [x] Proposal acceptance criteria verified
- [x] Ready for `sdd-spec-archive`
