# Tasks: Spec Consolidation & Delta Merge Lifecycle

> **Change ID:** `feat-spec-consolidation-lifecycle`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [x] Overhaul `skills/sdd-spec-archive/SKILL.md` (Step 3) to implement semantic consolidation (distinguishing new canonical specs vs deltas, executing content merges, version bumping, and safety verification).
- [x] Update `skills/sdd-spec-create/SKILL.md` (Step 4) and `skills/sdd-spec-create/resources/proposal-template.md` to map code impact to canonical domain specifications instead of source filenames.
- [x] Update `agents/sdd-code-explorer.md` to align suggested spec stubs with canonical specifications.
- [x] Update `rules/AGENTS.md` to add the canonical living spec invariant and forbid `*-delta.md` files in `openspec/specs/`, while strictly keeping line count <= 55 lines.
- [x] Update `skills/sdd-prompt-craft/resources/prompt-guide.md` line 70 to clarify delta specs scope under the active change directory.
- [x] Convert `openspec/specs/agent-sdd-prompt-architect.md` and `openspec/specs/prompt-engineering-workflow.md` from delta headers to canonical living spec format.
- [x] Update `validate-v3.sh` to add automated validation prohibiting any `*-delta.md` files in `openspec/specs/`.

## Test Tasks

- [x] Run `validate-v3.sh` to verify rule line count budget (<= 55 lines), YAML frontmatter, and canonical specs integrity.
- [x] Test negative assertion in `validate-v3.sh` ensuring it detects and fails if a `*-delta.md` file is placed in `openspec/specs/`.

## Documentation Tasks

- [x] Create `openspec/changes/feat-spec-consolidation-lifecycle/specs/spec-consolidation-lifecycle.md` documenting the new spec lifecycle architecture.
- [x] Update `openspec/specs/sdd-stack-contract.md` or living specs if required.

## Review Gate

- [x] All implementation tasks complete
- [x] All tests passing
- [x] Proposal acceptance criteria verified
- [x] Ready for `sdd-spec-archive`
