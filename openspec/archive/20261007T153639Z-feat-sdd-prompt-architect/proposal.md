# Proposal: Feature SDD Prompt Architect

> **Change ID:** `feat-sdd-prompt-architect`
> **Status:** draft
> **Author:** Antigravity Assistant
> **Created:** 2026-10-07
> **Last Updated:** 2026-10-07

---

## Summary

This change introduces a dedicated lightweight subagent (`sdd-prompt-architect`) powered by Gemini Flash (`flash`) and a companion skill (`sdd-prompt-craft`) containing modular prompt engineering templates and guidelines. It enables agents and users to generate high-precision, token-efficient prompt files (`prompt-*.md`) in the project root for heavier execution models (e.g., Claude Opus / Sonnet) without bloating the main session context.

## Motivation

1. **Local Flash Orchestration vs. External Web Gems:** Developers and orchestrating agents need automated, context-aware prompt generation within their active repository without switching to external web tools or losing local repository awareness.
2. **Progressive Disclosure Compliance:** Inlining prompt templates or engineering instructions into `rules/AGENTS.md` violates the 55-line budget and bloats `<user_rules>` in every heavy coding session. A dedicated skill (`sdd-prompt-craft`) and subagent (`sdd-prompt-architect`) encapsulate this capability on-demand.
3. **Phased Execution & Verification Gates:** Multi-phase implementations require structured prompts that guide execution models phase-by-phase with verification gates and cumulative walkthrough logging (`walkthrough.md` in pt-BR).

## Scope

### In Scope
- Create skill `sdd-prompt-craft` (`skills/sdd-prompt-craft/SKILL.md`) as the user entry point.
- Port `Universal Prompt Guide & Templates.md` into `skills/sdd-prompt-craft/resources/prompt-guide.md` with explicit walkthrough paths and Section 4 template selection rules.
- Create subagent `sdd-prompt-architect` (`agents/sdd-prompt-architect.md`) with model `flash`, read tools + `write_to_file` + `invoke_subagent` (no `run_command`), restricted to generating `prompt-*.md` in the project root.
- Evaluate and configure write-scope hardening in `hooks.json`.
- Update `validate-v3.sh` and `plugin.json` to register and validate the new skill, subagent, and resources.
- Cumulative walkthrough logging in `openspec/changes/feat-sdd-prompt-architect/walkthrough.md`.

### Out of Scope
- Direct modification of `rules/AGENTS.md`.
- Automated dispatch/execution of generated prompts (the subagent writes the file and presents a link; human or orchestrator decides when to dispatch).
- Modifying the root source guide `Universal Prompt Guide & Templates.md` or `prompt-sdd-prompt-architect.md`.

## Proposed Solution

### Approach
- **Skill Entry Point:** `sdd-prompt-craft` captures user intent (goal, target area, change context) in pt-BR and delegates prompt creation to `sdd-prompt-architect`.
- **Lightweight Subagent:** `sdd-prompt-architect` operates on `flash` with sandboxed least-privilege tools. It reads `skills/sdd-prompt-craft/resources/prompt-guide.md`, inspects `openspec/changes/` and `git status`, autonomously selects the appropriate template (T1 Discovery, T2 SDD Spec, T3 Phased Execution, T4 Direct Fix), writes the prompt file in the project root, and returns a clickable markdown link.
- **Write-Scope Conformance:** The subagent's instructions and hooks ensure writes are strictly restricted to `prompt-*.md` or `prompt.md` in the project root.

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `skills/sdd-prompt-craft/SKILL.md` | Create | Entry point skill for prompt crafting |
| `skills/sdd-prompt-craft/resources/prompt-guide.md` | Create | Ported prompt guide with section 4 selection table |
| `agents/sdd-prompt-architect.md` | Create | Subagent definition with Flash model and restricted tools |
| `hooks.json` | Modify | Write-scope PreToolUse hook recipe/entry |
| `validate-v3.sh` | Modify | Acceptance validation suite updates |
| `plugin.json` | Modify | Plugin description update |

### Data Model Changes (if applicable)
N/A — No schema or database changes.

## Acceptance Criteria

- [ ] **Given** an ambiguous or exploratory request, **When** `sdd-prompt-craft` runs, **Then** `prompt-discovery.md` using Template 1 is generated in the project root and a clickable link is returned in pt-BR without launching any execution agent.
- [ ] **Given** an approved change with `tasks.md`, **When** a phase execution prompt is requested, **Then** `prompt-<change-id>-phase-<N>.md` using Template 3 is generated and explicitly directs accumulating `openspec/changes/<change-id>/walkthrough.md`.
- [ ] **Given** a new feature request without an active change in `openspec/changes/`, **When** `sdd-prompt-craft` runs, **Then** `prompt-<change-id>-spec.md` using Template 2 is generated.
- [ ] **Given** an isolated bug or targeted adjustment, **When** `sdd-prompt-craft` runs, **Then** `prompt-fix-<target>.md` using Template 4 is generated.
- [ ] **Given** a target path not matching `prompt-*.md` or `prompt.md` in the project root, **When** `sdd-prompt-architect` attempts to write, **Then** the subagent refuses the action.
- [ ] **Given** the validation script `validate-v3.sh`, **When** executed, **Then** all checks for `sdd-prompt-craft`, `sdd-prompt-architect`, and resource files pass with 0 failures.

## Defensive Security & Validation Considerations

### Input Validation
- File naming and path targets are strictly validated against `^prompt(-.*)?\.md$` in the project root directory. Path traversal attempts (`../`) are refused.
- Change ID strings and phase numbers are sanitized to alphanumeric and hyphen characters.

### Secret Isolation
- No API keys, credentials, or secrets are used, logged, or hardcoded.
- Generated prompts adhere to zero-waste principles and do not embed environment secrets.

### Authorization & Authentication Impact
- N/A — Plugin runs locally within the Antigravity CLI environment.
- Subagent permissions are strictly bounded: least privilege tools (no `run_command`, sandboxed policy).

### Other Security Risks
- Unauthorized file modifications by subagent are mitigated by prompt instructions, absence of `run_command`, and hook policy.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `validate-v3.sh` | Automated Suite | 100% checks pass (frontmatter, line counts, JSON, resources) |
| TP-02 | Ambiguous user intent triggers Template 1 | Unit / Inspection | `prompt-discovery.md` generated with `/grill-me` structure |
| TP-03 | Approved change with `tasks.md` triggers Template 3 | Unit / Inspection | `prompt-<change-id>-phase-<N>.md` generated with `walkthrough.md` path |
| TP-04 | New feature intent triggers Template 2 | Unit / Inspection | `prompt-<change-id>-spec.md` generated |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Conflicting context signals | Logic Verification | Prompts user in pt-BR for template clarification rather than guessing |
| TE-02 | Attempted write outside project root | Security Boundary | Subagent refuses path |
| TE-03 | Subagent attempts to invoke execution agents | Safety Check | Prohibited by agent instructions |

### Test Commands
- **Run tests:** `bash validate-v3.sh`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Subagent attempts writes outside project root | Low | Med | Restrict tools (no `run_command`), explicit system prompt boundary, and PreToolUse hook |
| Misdetection of template on ambiguous project state | Low | Med | Subagent instructions require asking user in pt-BR when signals conflict |
| Prompt format drift from Universal Guide | Low | Low | Store guide in `skills/sdd-prompt-craft/resources/prompt-guide.md` and validate existence in `validate-v3.sh` |

## Delta Spec Stubs

### `specs/agent-sdd-prompt-architect.md`
Defines the `sdd-prompt-architect` subagent specification, frontmatter, model selection, permitted tools, and operational boundaries.

### `specs/prompt-engineering-workflow.md`
Defines the prompt engineering workflow, template taxonomy (T1-T4), signal detection heuristics, and walkthrough accumulation conventions.

## References

- [Universal Prompt Guide & Templates.md](../../Universal%20Prompt%20Guide%20&%20Templates.md)
- [plan-feat-sdd-prompt-architect.md](../../plan-feat-sdd-prompt-architect.md)
- [prompt-sdd-prompt-architect.md](../../prompt-sdd-prompt-architect.md)
