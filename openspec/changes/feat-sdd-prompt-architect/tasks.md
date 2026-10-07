# Tasks: feat-sdd-prompt-architect

> **Change ID:** `feat-sdd-prompt-architect`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Phase 1 — Skill `sdd-prompt-craft`
- [ ] Copy `Universal Prompt Guide & Templates.md` to `skills/sdd-prompt-craft/resources/prompt-guide.md` and append Section 4
- [ ] Create `skills/sdd-prompt-craft/SKILL.md` (< 500 lines, correct frontmatter)
- [ ] Verification: check line counts and template contents
- [ ] Local commit: `feat(skill): add sdd-prompt-craft`

## Phase 2 — Subagent `sdd-prompt-architect`
- [ ] Create `agents/sdd-prompt-architect.md` (flash, no run_command, scoped tools)
- [ ] Verification: compare frontmatter with `agents/sdd-code-explorer.md`
- [ ] Local commit: `feat(agent): add sdd-prompt-architect`

## Phase 3 — Write-Scope Hardening (Hooks)
- [ ] Evaluate and configure write-scope PreToolUse hook in `hooks.json`
- [ ] Verification: parse `hooks.json` and ensure valid JSON schema
- [ ] Local commit: `feat(hooks): scope sdd-prompt-architect writes` (or record limitation)

## Phase 4 — Registration & Validation
- [ ] Update `validate-v3.sh` to include `sdd-prompt-craft`, `sdd-prompt-architect`, and resource checks
- [ ] Update `plugin.json` description
- [ ] Verification: run `validate-v3.sh` and ensure 100% pass rate
- [ ] Local commit: `chore: register sdd-prompt-craft and sdd-prompt-architect`
- [ ] Final cumulative walkthrough update and user verification readiness

## Review Gate
- [ ] All implementation tasks complete
- [ ] All tests passing (`validate-v3.sh`)
- [ ] Proposal acceptance criteria verified
- [ ] Ready for `sdd-spec-archive`
