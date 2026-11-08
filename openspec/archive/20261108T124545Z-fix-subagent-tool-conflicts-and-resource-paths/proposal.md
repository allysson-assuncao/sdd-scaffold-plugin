# Proposal: Fix Subagent Tool Conflicts and Resource Paths

> **Change ID:** `fix-subagent-tool-conflicts-and-resource-paths`
> **Status:** approved
> **Author:** @antigravity
> **Created:** 2026-11-08
> **Last Updated:** 2026-11-08

---

## Summary

Resolves the subagent construction crash (`failed to construct executor: tool name conflict: multiple tools resolved with name "read_file"`) caused by declaring legacy tool aliases (`view_file`, `write_to_file`) concurrently with canonical tools (`read_file`, `write_file`) in subagent configurations (`agents/*.md`). Additionally fixes relative path resolution failures for skill template resources in `sdd-init`, `sdd-spec-create`, and other skills when executed outside the plugin directory, and updates `validate-v3.sh` with automated assertions.

## Motivation

1. **Subagent Execution Failure:** When invoking `sdd-code-explorer`, `sdd-spec-auditor`, or `sdd-prompt-architect`, the Antigravity agent runtime aborts with `tool name conflict: multiple tools resolved with name "read_file"` because aliases like `view_file` resolve to `read_file` internally. Having both entries triggers duplicate registration errors.
2. **Resource Resolution Failures:** External agents invoking `sdd-init` from application repositories fail to read templates because `read_file(Path="resources/...")` resolves relative to the target repository CWD rather than the skill's installation directory. This led agents to assume templates were missing from disk.

## Scope

### In Scope
- Remove legacy tool aliases (`view_file`, `write_to_file`) from `agents/sdd-code-explorer.md`, `agents/sdd-spec-auditor.md`, and `agents/sdd-prompt-architect.md`.
- Update canonical specification `openspec/specs/agent-sdd-prompt-architect.md` via delta spec.
- Update `skills/sdd-init/SKILL.md` and `skills/sdd-spec-create/SKILL.md` (and other skills with resources) to use explicit markdown links and clear path resolution instructions.
- Update `skills/sdd-agent-create/SKILL.md` to document and enforce canonical tool naming without duplicate aliases.
- Add regression tests to `validate-v3.sh` to prevent future tool alias collisions and ensure template resource availability.

### Out of Scope
- Creating new subagents or modifying plugin hooks architecture.
- Altering the core SDD spec lifecycle contracts.

## Proposed Solution

### Approach
1. Clean the `tools:` block in all subagent YAML frontmatter, keeping only the canonical native names: `read_file`, `grep_search`, `find_by_name`, `list_dir`, `write_file`, `invoke_subagent`, `send_message`.
2. Update skills documentation to instruct agents to resolve template paths from the skill installation directory (`~/.gemini/config/skills/<skill>/resources/` or `.agents/skills/<skill>/resources/`) or click the relative links, preventing failed reads from the target workspace root.
3. Add automated checks in `validate-v3.sh` to ensure no subagent file in `agents/*.md` contains conflicting aliases (`view_file` alongside `read_file`, or `write_to_file` alongside `write_file`).

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `agents/sdd-code-explorer.md` | Modify | Remove `view_file` |
| `agents/sdd-spec-auditor.md` | Modify | Remove `view_file` |
| `agents/sdd-prompt-architect.md` | Modify | Remove `view_file` and `write_to_file` |
| `skills/sdd-agent-create/SKILL.md` | Modify | Update tool advice to avoid alias conflicts |
| `skills/sdd-init/SKILL.md` | Modify | Add markdown links and path resolution guidance |
| `skills/sdd-spec-create/SKILL.md` | Modify | Add markdown links and path resolution guidance |
| `validate-v3.sh` | Modify | Add assertions against duplicate tool aliases |
| `openspec/specs/agent-sdd-prompt-architect.md` | Modify (post-archive) | Update canonical spec tool contract |

### Data Model Changes
N/A — no database or shared schema models involved.

## Acceptance Criteria

- [ ] **Given** a subagent definition in `agents/sdd-code-explorer.md` **When** inspected **Then** it must declare `read_file` without `view_file`.
- [ ] **Given** a subagent definition in `agents/sdd-prompt-architect.md` **When** inspected **Then** it must declare `read_file` and `write_file` without `view_file` or `write_to_file`.
- [ ] **Given** the `sdd-code-explorer` subagent **When** invoked via `invoke_subagent` **Then** the executor constructs successfully without `tool name conflict`.
- [ ] **Given** `validate-v3.sh` **When** executed **Then** all checks pass, including new assertions preventing tool alias conflicts.
- [ ] **Given** `skills/sdd-init/SKILL.md` **When** read by an agent **Then** it provides explicit relative markdown links and path resolution instructions for template files in `resources/`.

## Defensive Security & Validation Considerations

### Input Validation
- Subagent frontmatter YAML continues to enforce `subagent: true`, `mainAgent: false`, and `commandExecutionPolicy: sandbox`.
- Path resolution in skills guides agents to sanitized relative/canonical paths.

### Secret Isolation
- N/A — no secrets or credentials touched.

### Authorization & Authentication Impact
- N/A — internal plugin configuration only.

### Other Security Risks
- Eliminating duplicate tool entries prevents undefined behavior in tool dispatch inside the sandbox.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `validate-v3.sh` | Static Analysis | All tests pass (89+ assertions) |
| TP-02 | Invoke `sdd-code-explorer` | Integration | Subagent starts and replies without executor crash |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Add `view_file` alongside `read_file` in any agent | Static Analysis | `validate-v3.sh` detects conflict and fails |

### Test Commands
- **Run validation suite:** `./validate-v3.sh`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Legacy environments expecting `view_file` | Low | Low | Antigravity CLI and 2.0 map `view_file` to `read_file`; using `read_file` directly is universally supported |

## Specification Changes & Delta Stubs
- `specs/agent-sdd-prompt-architect-delta.md` targeting `openspec/specs/agent-sdd-prompt-architect.md`.
