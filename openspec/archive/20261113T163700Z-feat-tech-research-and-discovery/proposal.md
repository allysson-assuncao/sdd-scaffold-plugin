# Proposal: Tech Research and Discovery Alignment Capabilities

> **Change ID:** `feat-tech-research-and-discovery`
> **Status:** approved
> **Author:** @allysson-assuncao
> **Created:** 2026-11-13
> **Last Updated:** 2026-11-13

---

## Summary

Add two SDD-agnostic interactive skills (`tech-research` and `discovery-align`) and one lightweight read-only subagent (`tech-profiler`) to `agentic-dev-workflow`. Together, they automate stack selection, workspace context investigation, solution option comparison, and structured `/grill-me` user alignment directly in the active chat session—producing either SDD artifacts (`openspec/specs/sdd-stack-contract.md` updates and `sdd-spec-create` handoffs) or standalone root decision reports (`tech-decision-<topic>.md` / `discovery-<topic>.md`) on demand.

## Motivation

1. **Repetitive Manual Prompting for Stack & Architecture Decisions:** When starting a new feature or refactoring without a defined technology stack or clear architectural approach, the user currently has to repeat detailed instructions telling the agent to inspect the workspace, search for reference patterns/technologies, propose trade-offs, and interview them via `/grill-me`.
2. **Gap Between Offline Prompt Generation (`sdd-prompt-craft`) and Live Chat Execution:** While `skills/sdd-prompt-craft/resources/prompt-guide.md` includes Template 1 (`prompt-discovery.md`), `sdd-prompt-craft` only generates a static prompt file in the project root for another executor rather than running the investigation and alignment interactively in the current session.
3. **Subagent Sandbox Network Constraints:** Sandboxed subagents (`commandExecutionPolicy: sandbox`) operate without internet access and cannot execute `search_web`. Separating local stack profiling (`tech-profiler` subagent) from live web research and interactive interviewing (orchestrated by the `tech-research` skill in the main agent) keeps main-session context lean while leveraging native `search_web` capabilities.

## Scope

### In Scope
- Create `agents/tech-profiler.md`: a read-only subagent (`model: flash`, `commandExecutionPolicy: sandbox`, canonical tools `read_file`, `grep_search`, `find_by_name`, `list_dir`, `send_message`) that inspects workspace manifests (`package.json`, `pom.xml`, `pyproject.toml`, Dockerfiles, `openspec/specs/sdd-stack-contract.md`, config files) and returns a structured stack inventory and constraints report.
- Create `skills/tech-research/SKILL.md` and `skills/tech-research/resources/tech-decision-template.md`:
  - Triggered by natural-language requests involving technology/library/stack selection or architectural comparison.
  - Invokes `tech-profiler` to map workspace demands/constraints, executes `search_web` in the main agent to evaluate reference architectures and market options, presents 2–4 candidate options with trade-offs in chat, and aligns with the user via `/grill-me` (one question at a time with a recommended option).
  - On-demand output: updates `openspec/specs/sdd-stack-contract.md` (or hands off to `sdd-spec-create`) in SDD mode, or writes `tech-decision-<topic>.md` in the workspace root (or chat-only summary) in non-SDD mode.
- Create `skills/discovery-align/SKILL.md` and `skills/discovery-align/resources/discovery-report-template.md`:
  - Triggered by natural-language requests presenting a new feature scope, ambiguous requirements, or pending design decisions.
  - Reuses `sdd-code-explorer` (and native `research` when needed) to inspect relevant workspace context without introducing a redundant code-scanning subagent.
  - Presents 2–3 initial solution approaches with trade-offs in chat, conducts an interactive `/grill-me` alignment interview, and upon completion either initiates `sdd-spec-create` (SDD mode) or generates `discovery-<topic>.md` in the root / proceeds to direct implementation (non-SDD mode).
- Update `skills/sdd-prompt-craft/SKILL.md` and `skills/sdd-prompt-craft/resources/prompt-guide.md` to clarify the trigger boundary between generating offline `prompt-*.md` files (`sdd-prompt-craft`) versus executing live interactive discovery/research in the current chat (`discovery-align` and `tech-research`).
- Update `validate-v3.sh` and `README.md` to register and validate `tech-research`, `discovery-align`, and `tech-profiler`.

### Out of Scope
- Adding a second subagent for `discovery-align` (it intentionally reuses `sdd-code-explorer` and native `research` to avoid subagent role overlap).
- Enabling shell execution (`run_command`) or write permissions in `agents/tech-profiler.md`.
- Automatically writing root `tech-decision-*.md` or `discovery-*.md` files when the user chooses to proceed directly into `openspec/changes/` via `sdd-spec-create`.

## Proposed Solution

### Approach
First, we introduce `agents/tech-profiler.md` conforming strictly to the Antigravity subagent contract (`subagent: true`, `mainAgent: false`, `model: flash`, `commandExecutionPolicy: sandbox`, canonical read-only tools `read_file`, `grep_search`, `find_by_name`, `list_dir`, `send_message`, and zero legacy tool aliases). Its responsibility is strictly bounded to reading project manifests, lockfiles, configuration files, and `openspec/specs/sdd-stack-contract.md` (if present), returning a structured Markdown summary of Current Stack Identity, Architectural Patterns, Constraints, and Detected Gaps.

Second, we create `skills/tech-research/SKILL.md` (with `resources/tech-decision-template.md`). When activated by progressive disclosure, the main agent: (1) delegates local workspace profiling to `tech-profiler`; (2) uses `search_web` and domain knowledge to research current standards, libraries, and reference architectures tailored to the project's constraints; (3) presents a structured comparison of 2–4 options in chat; (4) enters `/grill-me` mode using `ask_question` (one question at a time, recommended option first) to finalize the technology choice; and (5) persists the outcome on demand—updating `openspec/specs/sdd-stack-contract.md` or launching `sdd-spec-create` when using SDD, or writing `tech-decision-<topic>.md` in the workspace root (or keeping it in chat) when working without SDD.

Third, we create `skills/discovery-align/SKILL.md` (with `resources/discovery-report-template.md`). When activated for a new scope or ambiguous feature request, the main agent: (1) delegates codebase mapping to `sdd-code-explorer` (or `research`); (2) synthesizes findings and presents 2–3 concrete implementation approaches with pros, cons, and open questions in chat; (3) conducts a `/grill-me` interview via `ask_question` until all design branches are resolved; and (4) hands off on demand—either directly invoking `sdd-spec-create` with the aligned decisions or generating `discovery-<topic>.md` in the project root for non-SDD workflows. Finally, `sdd-prompt-craft/SKILL.md`, `README.md`, and `validate-v3.sh` are updated to reflect the 14-skill, 4-subagent catalog.

### Impacted Files
| File | Change Type | Notes |
|------|-------------|-------|
| `agents/tech-profiler.md` | Create | Read-only `flash` sandbox subagent for project stack and manifest profiling |
| `skills/tech-research/SKILL.md` | Create | Interactive skill orchestrating `tech-profiler`, `search_web`, and `/grill-me` stack alignment |
| `skills/tech-research/resources/tech-decision-template.md` | Create | Template for root `tech-decision-<topic>.md` ADR reports |
| `skills/discovery-align/SKILL.md` | Create | Interactive skill orchestrating `sdd-code-explorer`, approach proposals, `/grill-me`, and SDD/report handoff |
| `skills/discovery-align/resources/discovery-report-template.md` | Create | Template for root `discovery-<topic>.md` alignment reports |
| `skills/sdd-prompt-craft/SKILL.md` | Modify | Clarify description boundary (offline `prompt-*.md` generation vs. live `discovery-align` / `tech-research`) |
| `skills/sdd-prompt-craft/resources/prompt-guide.md` | Modify | Cross-reference `discovery-align` and `tech-research` in Template 1 notes |
| `README.md` | Modify | Document `tech-research`, `discovery-align`, and `tech-profiler` in the plugin catalog |
| `validate-v3.sh` | Modify | Add validation checks for `tech-research`, `discovery-align`, and `agents/tech-profiler.md` |

### Data Model Changes (if applicable)
N/A — no database schemas or external API contracts are modified. All new skills and subagents follow Antigravity 2.0 YAML frontmatter contracts.

## Acceptance Criteria

- [x] **Given** `agents/tech-profiler.md`, **When** validated by `validate-v3.sh` and `agy plugin validate .`, **Then** it declares `subagent: true`, `mainAgent: false`, `model: flash`, `commandExecutionPolicy: sandbox`, canonical read-only tools (`read_file`, `grep_search`, `find_by_name`, `list_dir`, `send_message`), and contains no legacy aliases (`view_file`, `write_to_file`).
- [x] **Given** `skills/tech-research/SKILL.md` and `skills/discovery-align/SKILL.md`, **When** checked by `validate-v3.sh`, **Then** both files have valid YAML frontmatter (`name` and `description`), are under `500` lines, and resolve their adjacent `./resources/*.md` templates.
- [x] **Given** a user prompt asking to choose a technology or architecture for a new or refactored capability, **When** `tech-research` is activated, **Then** the workflow mandates invoking `tech-profiler` for local context, using `search_web` in the main agent, presenting 2–4 options with trade-offs, aligning via `/grill-me` (one question at a time with recommendation), and persisting to `sdd-stack-contract.md` / `sdd-spec-create` (SDD) or `tech-decision-<topic>.md` / chat (non-SDD).
- [x] **Given** a user prompt describing a new feature scope with open design decisions, **When** `discovery-align` is activated, **Then** the workflow mandates delegating codebase scan to `sdd-code-explorer` / `research`, presenting 2–3 initial solution approaches in chat, aligning via `/grill-me`, and handing off to `sdd-spec-create` (SDD) or `discovery-<topic>.md` / direct execution (non-SDD).
- [x] **Given** the updated `sdd-prompt-craft/SKILL.md`, **When** compared with `discovery-align` and `tech-research`, **Then** `sdd-prompt-craft` explicitly scopes its trigger to generating offline `prompt-*.md` files so progressive disclosure does not collide with live interactive discovery.

## Defensive Security & Validation Considerations

### Input Validation
- `tech-research` and `discovery-align` validate `<topic>` slugs used for optional root report filenames (`tech-decision-<topic>.md`, `discovery-<topic>.md`) as lowercase `kebab-case` (`^[a-z][a-z0-9-]*$`), preventing path traversal or invalid filesystem characters.

### Secret Isolation
- `agents/tech-profiler.md` explicitly instructs the subagent never to read or echo `.env`, secret files, private keys, or credentials when profiling workspace manifests, complementing the active `sdd-readonly-auto-allow` guard in `scripts/sdd-readonly-guard.mjs`.

### Authorization & Authentication Impact
- N/A — `tech-profiler` runs in a read-only sandbox (`commandExecutionPolicy: sandbox`) with no write or shell tools, and the skills operate locally within the user's Antigravity session.

### Other Security Risks
- **Unverified Third-Party Packages in `tech-research`:** `skills/tech-research/SKILL.md` instructs the agent to evaluate package maintenance status, security posture, and license compatibility before recommending external libraries.

## Testing Strategy & Shift-Left Plan

### Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TP-01 | Run `agy plugin validate .` with the 14 skills and 4 subagents | Integration | CLI outputs `skills 14 · agents 4` and `Validation passed` |
| TP-02 | Run `bash validate-v3.sh` with new skill and subagent checks | Integration | All checks pass (`0 failed`) |
| TP-03 | Verify `skills/tech-research/SKILL.md` and `skills/discovery-align/SKILL.md` frontmatter and line counts | Unit | Valid YAML frontmatter (`name`, `description`) and `< 500` lines each |
| TP-04 | Verify `agents/tech-profiler.md` tool list and sandbox policy | Unit | Contains only canonical read-only tools and `commandExecutionPolicy: sandbox` |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | Check `agents/tech-profiler.md` for forbidden legacy tool aliases (`view_file`, `write_to_file`) | Unit | `validate-v3.sh` confirms 0 occurrences of legacy tool aliases |
| TE-02 | Check `tech-research` and `discovery-align` behavior when `openspec/` does not exist in target workspace | Unit | Both skills define clean fallback to on-demand root report (`tech-decision-<topic>.md` / `discovery-<topic>.md`) or chat-only output without failing |
| TE-03 | Check resource path references in `tech-research/SKILL.md` and `discovery-align/SKILL.md` | Unit | Relative `./resources/...` paths resolve to existing template files |

### Test Commands
- **Run validation suite:** `bash validate-v3.sh`
- **Plugin schema check:** `agy plugin validate .`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Trigger overlap between `sdd-prompt-craft`, `discovery-align`, and `tech-research` | Med | Med | Make `description` frontmatter mutually exclusive: `sdd-prompt-craft` only when user asks to *generate a prompt file*; `tech-research` when *choosing technologies/stack*; `discovery-align` when *aligning scope/architecture in chat* |
| `tech-profiler` attempting web search inside sandbox | Low | Med | Explicitly state in `agents/tech-profiler.md` that it only inspects local files and that `search_web` is performed by the parent agent |
| Unwanted root files cluttering SDD repositories | Low | Low | Enforce on-demand persistence rule: when proceeding to SDD (`openspec/`), never write extra `discovery-*.md` files in root unless explicitly requested |

## Specification Changes & Delta Stubs

### `specs/tech-research-and-discovery.md`
- **Target Canonical Spec:** `New Specification` (`openspec/specs/tech-research-and-discovery.md`)
- **Summary of Updates:** Define canonical requirements for `tech-research`, `tech-profiler`, and `discovery-align`, including `/grill-me` interview rules, local-vs-web responsibility split, and on-demand SDD vs. non-SDD output artifacts.

### `specs/prompt-engineering-workflow-delta.md`
- **Target Canonical Spec:** `openspec/specs/prompt-engineering-workflow.md`
- **Summary of Updates:** Clarify trigger boundaries between offline prompt file generation (`sdd-prompt-craft` Template 1) and live interactive session alignment (`discovery-align` and `tech-research`).

## References

- `ideia_novas_skills_e_agentes.txt`
- `skills/sdd-prompt-craft/SKILL.md`
- `skills/sdd-prompt-craft/resources/prompt-guide.md`
- `skills/sdd-init/resources/sdd-stack-contract.md`
- `agents/sdd-code-explorer.md`
