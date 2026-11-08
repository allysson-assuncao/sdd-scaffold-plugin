# Tasks: Fix Subagent Tool Conflicts and Resource Paths

> **Change ID:** `fix-subagent-tool-conflicts-and-resource-paths`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [x] Remove `view_file` alias from `agents/sdd-code-explorer.md`
- [x] Remove `view_file` alias from `agents/sdd-spec-auditor.md`
- [x] Remove `view_file` and `write_to_file` aliases from `agents/sdd-prompt-architect.md`
- [x] Update `skills/sdd-agent-create/SKILL.md` to document and advise against alias conflicts
- [x] Update `skills/sdd-init/SKILL.md` with explicit markdown links and path resolution guidance
- [x] Update `skills/sdd-spec-create/SKILL.md` with explicit markdown links and path resolution guidance

## Test Tasks

- [x] Add assertions to `validate-v3.sh` ensuring no subagent has duplicate tool aliases
- [x] Execute `./validate-v3.sh` and verify all tests pass (95/95 passed)
- [x] Execute integration check with `invoke_subagent` to verify dynamic subagent startup and communication

## Documentation Tasks

- [x] Create delta spec `specs/agent-sdd-prompt-architect-delta.md`

## Review Gate

- [x] All implementation tasks complete
- [x] All tests passing
- [x] Proposal acceptance criteria verified
- [x] Ready for `sdd-spec-archive`
