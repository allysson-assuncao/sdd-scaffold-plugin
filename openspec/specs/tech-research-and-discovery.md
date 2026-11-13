---
id: "spec-tech-research-and-discovery"
title: "Interactive Tech Research & Discovery Alignment Workflows"
version: "1.0.0"
status: "active"
owners:
  - "@allysson-assuncao"
scope:
  paths:
    - "agents/tech-profiler.md"
    - "skills/tech-research/**"
    - "skills/discovery-align/**"
resources:
  - "skills/tech-research/resources/tech-decision-template.md"
  - "skills/discovery-align/resources/discovery-report-template.md"
---

# Interactive Tech Research & Discovery Alignment Workflows — Living Specification

> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from `openspec/changes/`.

---

## Context & Objectives

Developers initiating a new feature or refactoring often need structured assistance to either (1) research and select an appropriate technology stack/architecture or (2) investigate the existing codebase, evaluate candidate implementation approaches, and align on open design decisions via `/grill-me` directly in the active chat. This specification governs the `tech-research` and `discovery-align` skills and the `tech-profiler` read-only subagent across both SDD and non-SDD workspaces.

## Functional Requirements

- **[RF-01] `tech-profiler` Read-Only Subagent:** `agents/tech-profiler.md` MUST operate with `subagent: true`, `mainAgent: false`, `model: flash`, `commandExecutionPolicy: sandbox`, and canonical read-only tools (`read_file`, `grep_search`, `find_by_name`, `list_dir`, `send_message`). It MUST inspect workspace dependency manifests, build files, configuration files, and `openspec/specs/sdd-stack-contract.md` (when present) and return a structured report covering Stack Identity, Architectural Patterns, Technical Constraints, and Open Gaps.
- **[RF-02] `tech-research` Skill Workflow:** When activated for stack, library, or architectural pattern selection, `skills/tech-research/SKILL.md` MUST:
  1. Invoke `tech-profiler` to gather workspace constraints without polluting main-session context;
  2. Use `search_web` and reference architectures in the main agent to evaluate options against workspace constraints, maintenance health, and security posture;
  3. Present 2–4 candidate options with pros, cons, and fit analysis in the chat (`pt-BR` when interacting with a Portuguese-speaking user);
  4. Conduct an interactive `/grill-me` interview via `ask_question` (one question at a time, recommended option prefixed with `(Recommended)`) to finalize the selection.
- **[RF-03] `discovery-align` Skill Workflow:** When activated for feature discovery, ambiguous scope, or architectural alignment, `skills/discovery-align/SKILL.md` MUST:
  1. Delegate codebase impact and context scanning to `sdd-code-explorer` (and native `research` if broader context is needed);
  2. Present a concise context summary and 2–3 initial implementation approaches with trade-offs and pending decisions in the chat;
  3. Conduct an interactive `/grill-me` interview via `ask_question` (one question at a time, recommended option prefixed with `(Recommended)`) until all design ambiguities are resolved.
- **[RF-04] On-Demand Persistence & Handoff:** Upon completing `/grill-me` alignment in either `tech-research` or `discovery-align`:
  - If the user opts to follow the SDD pipeline (`openspec/`), the agent MUST proceed directly to updating `openspec/specs/sdd-stack-contract.md` and/or invoking `sdd-spec-create` without generating redundant root report files;
  - If the project does not use SDD (or the user opts out of SDD for the task), the agent MUST offer on-demand persistence to `tech-decision-<topic>.md` or `discovery-<topic>.md` in the workspace root (using `./resources/tech-decision-template.md` or `./resources/discovery-report-template.md`) or keep the aligned summary in chat before direct implementation.

## Non-Functional Requirements

- **[RNF-01] Tool Alias Safety & Context Budget:** `agents/tech-profiler.md` MUST NOT declare legacy tool aliases (`view_file`, `write_to_file`), and both `SKILL.md` files MUST remain under `500` lines.
- **[RNF-02] Secret & Path Safety:** `tech-profiler` MUST NOT read or output secret files (`.env`, private keys, credentials), and any `<topic>` slug used for root report filenames MUST conform to `^[a-z][a-z0-9-]*$`.

## Out of Scope

- Creating a separate code-scanning subagent for `discovery-align` (which reuses `sdd-code-explorer` and `research`).
- Offline prompt file generation (`prompt-*.md`), which remains governed by `sdd-prompt-craft` and `sdd-prompt-architect`.

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-11-13 | @allysson-assuncao | Initial canonical specification (`feat-tech-research-and-discovery`) |
