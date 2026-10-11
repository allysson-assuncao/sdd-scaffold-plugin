# Proposal: Spec Consolidation & Delta Merge Lifecycle

> **Change ID:** `feat-spec-consolidation-lifecycle`
> **Status:** approved
> **Author:** Antigravity & User
> **Created:** 2026-10-11
> **Last Updated:** 2026-10-11

---

## Summary

This change updates `sdd-scaffold-plugin` to establish a robust, clean specification lifecycle for Spec-Driven Development (SDD). It eliminates the naive 1:1 file copying of change delta specs into `openspec/specs/`, enforces true semantic consolidation of living specs during archival, updates spec stub generation to map code impact to canonical domain specifications, and introduces strict invariants preventing `*-delta.md` files from residing in the canonical `openspec/specs/` namespace.

## Motivation

In projects utilizing `sdd-scaffold-plugin`, archiving changes naively copied `*-delta.md` files directly into `openspec/specs/`. This caused:
1. Canonical namespace pollution with fragmented delta artifacts.
2. Canonical living specs (`architecture-core.md`, etc.) remaining stale and never receiving merged updates.
3. Collisions and data loss when subsequent change phases overwrote generic delta filenames in `openspec/specs/`.
4. Decoupling between code impact analysis and canonical architectural specifications.

## Scope

### In Scope
- Overhaul Step 3 of `skills/sdd-spec-archive/SKILL.md` to implement semantic consolidation: promoting new module specs to canonical without `-delta`, semantically merging deltas into existing canonical specs, incrementing spec version numbers, and adding a validation gate blocking any `*-delta.md` file from `openspec/specs/`.
- Update Step 4 of `skills/sdd-spec-create/SKILL.md` and `skills/sdd-spec-create/resources/proposal-template.md` to decouple individual source code files from spec stubs, mapping impacted code to canonical domain specifications.
- Update `agents/sdd-code-explorer.md` so that the code explorer subagent suggests mappings from code changes to canonical target specifications.
- Update `rules/AGENTS.md` to add the canonical invariant (only consolidated living specs in `openspec/specs/`, forbidding `*-delta.md`) while respecting the strict 55-line ceiling.
- Update `validate-v3.sh` with automated checks asserting no `*-delta.md` files in `openspec/specs/`.
- Fix phrasing in `skills/sdd-prompt-craft/resources/prompt-guide.md` regarding delta specs scope.
- Sanitize this repository's own canonical specs (`openspec/specs/agent-sdd-prompt-architect.md` and `openspec/specs/prompt-engineering-workflow.md`) into valid canonical living specifications.

### Out of Scope
- Backward compatibility or automatic migration tools for external projects (each external repository cleans its own specs independently).
- Heuristic recognition of flawed legacy states in other projects.

## Proposed Solution

### Approach
1. **Canonical Invariant:** Enforce that `openspec/specs/` is the single source of truth ("Living Documentation") containing ONLY consolidated specs formatted per `spec-template.md`. Under no circumstances will any `*-delta.md` file be allowed in `openspec/specs/`.
2. **Delta Scope & Archival:** Delta specs exist strictly in `openspec/changes/<change-id>/specs/` during planning/implementation and are permanently preserved in `openspec/archive/<timestamp>-<change-id>/specs/` upon archival.
3. **Semantic Consolidation on Archive:**
   - When `sdd-spec-archive` processes `changes/<change-id>/specs/`:
     - If the spec is a new subsystem spec: it is promoted directly to `openspec/specs/<spec-name>.md`.
     - If the spec is a delta updating an existing canonical spec: the agent reads both the existing canonical spec and the delta spec, merges functional requirements, tables, and contracts, updates version and revision history, and saves the updated canonical spec.
   - An archival safety check asserts that no `*-delta.md` file exists in `openspec/specs/`.
4. **Code Impact to Spec Mapping:** In `sdd-spec-create` and `sdd-code-explorer`, impact analysis associates affected source files with functional/domain specifications rather than generating 1:1 delta stubs per code file.

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `skills/sdd-spec-archive/SKILL.md` | Modify | Overhaul Step 3 with semantic consolidation and safety guard |
| `skills/sdd-spec-create/SKILL.md` | Modify | Decouple code files from spec stubs, guide domain spec mapping |
| `skills/sdd-spec-create/resources/proposal-template.md` | Modify | Replace naive delta stubs with canonical spec mapping |
| `agents/sdd-code-explorer.md` | Modify | Update suggested spec stubs prompt to map to canonical specs |
| `rules/AGENTS.md` | Modify | Add canonical living spec invariant within <= 55 lines limit |
| `skills/sdd-prompt-craft/resources/prompt-guide.md` | Modify | Clarify delta specs scope under change directory |
| `validate-v3.sh` | Modify | Add verification check preventing `*-delta.md` in `openspec/specs/` |
| `openspec/specs/agent-sdd-prompt-architect.md` | Modify | Standardize into canonical living spec format |
| `openspec/specs/prompt-engineering-workflow.md` | Modify | Standardize into canonical living spec format |

### Data Model Changes (if applicable)
N/A — Workflow and documentation specification schemas only.

## Acceptance Criteria

- [ ] **Given** a change with delta specs targeting an existing canonical spec, **When** `sdd-spec-archive` is executed, **Then** the updates are semantically merged into `openspec/specs/<canonical>.md` and no `*-delta.md` files are created in `openspec/specs/`.
- [ ] **Given** a change introducing a new module specification, **When** `sdd-spec-archive` is executed, **Then** the new spec is promoted to `openspec/specs/<name>.md` conforming to canonical living spec standards.
- [ ] **Given** `rules/AGENTS.md`, **When** line count is verified by `validate-v3.sh`, **Then** the total line count remains <= 55 lines while enforcing the canonical-only invariant.
- [ ] **Given** `validate-v3.sh`, **When** executed on the repository, **Then** all validation tests pass, including the new check asserting zero `*-delta.md` files in `openspec/specs/`.
- [ ] **Given** `openspec/specs/agent-sdd-prompt-architect.md` and `openspec/specs/prompt-engineering-workflow.md`, **When** inspected, **Then** neither file contains `# Delta Spec:` headers and both conform to canonical living spec format.

## Defensive Security & Validation Considerations

### Input Validation
- All change IDs and spec file paths handled by skills are validated for path traversal prevention and naming conformity (`kebab-case`).
- `validate-v3.sh` performs regex and glob validation to prevent invalid file paths or unauthorized file placement.

### Secret Isolation
- N/A — No secrets, credentials, or API keys are required or touched by this plugin.

### Authorization & Authentication Impact
- N/A — Plugin operates within local Antigravity CLI workspace context.

### Other Security Risks
- Path traversal: Ensure that spec merging algorithms strictly confine file reads/writes to `openspec/specs/`, `openspec/changes/`, and `openspec/archive/`.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `validate-v3.sh` | Shell Integration Test | All checks pass (Rule line count, YAML frontmatter, no `*-delta.md` in `openspec/specs/`) |
| TP-02 | Verify `sdd-spec-archive/SKILL.md` Step 3 | Documentation Review | Clear consolidation algorithm for new vs delta specs with safety check |
| TP-03 | Verify `sdd-spec-create/SKILL.md` Step 4 | Documentation Review | Impact analysis correctly maps code to canonical specs |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Invariant violation in `openspec/specs/` | Script Test | `validate-v3.sh` fails if a dummy `foo-delta.md` is placed in `openspec/specs/` |
| TE-02 | Line budget in `rules/AGENTS.md` | Script Test | Total lines in `rules/AGENTS.md` remains strictly <= 55 |

### Test Commands
- **Run tests:** `./validate-v3.sh`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Agent fails to semantically merge complex deltas | Low | Medium | Provide unambiguous instructions in `SKILL.md` detailing step-by-step section merging and version bumping |
| `rules/AGENTS.md` exceeds 55-line ceiling | Medium | High | Condense existing sentences in `rules/AGENTS.md` to leave ample headroom (target <= 50 lines) |
| Collision during concurrent changes | Low | Medium | Each change remains isolated in its own `openspec/changes/<id>/` folder until serialized archival |

## Delta Spec Stubs

### `specs/spec-consolidation-lifecycle.md`
New canonical specification detailing the architecture of living specs, delta scoping, consolidation during archive, and invariant enforcement.

## References
- [SDD_PLUGIN_SPEC_MERGE_PROPOSAL.md](file:///home/anybody/Documents/Projects/sdd-scaffold-plugin/SDD_PLUGIN_SPEC_MERGE_PROPOSAL.md)
