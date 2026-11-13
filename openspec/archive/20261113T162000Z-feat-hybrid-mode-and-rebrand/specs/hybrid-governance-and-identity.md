---
id: "spec-hybrid-governance-and-identity"
title: "Hybrid SDD/Non-SDD Governance & Plugin Identity"
version: "1.0.0"
status: "draft"
owners:
  - "@allysson-assuncao"
scope:
  paths:
    - "plugin.json"
    - "rules/AGENTS.md"
    - "README.md"
    - "validate-v3.sh"
resources: []
---

# Hybrid SDD/Non-SDD Governance & Plugin Identity — Living Specification

> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from `openspec/changes/`.

---

## Context & Objectives

`agentic-dev-workflow` (formerly `sdd-scaffold-plugin`) is a global Antigravity 2.0 plugin that supports both structured Spec-Driven Development (SDD) repositories and lightweight or legacy repositories without `openspec/`. This specification defines the plugin manifest identity, the Dual-Mode Governance rules in `rules/AGENTS.md`, and the root documentation invariants.

## Functional Requirements

- **[RF-01] Plugin Manifest Identity:** `plugin.json` MUST declare `"name": "agentic-dev-workflow"`, `"version": "4.0.0"`, and `"$schema": "https://antigravity.google/schemas/v1/plugin.json"`.
- **[RF-02] Strict SDD Mode (`openspec/` Present):** When `openspec/` exists in the active workspace, `rules/AGENTS.md` MUST enforce the Spec-First Hard Stop: no structural code mutations (`write_to_file`, `replace_file_content`, or mutating `run_command`) may occur during planning or before a `proposal.md` in `openspec/changes/<change-id>/` has been approved by the user and audited via `sdd-spec-validate`.
- **[RF-03] Adaptive Mode (`openspec/` Absent):** When `openspec/` does not exist in the active workspace, `rules/AGENTS.md` MUST instruct the agent to recommend initializing SDD (`sdd-init`) or creating a spec for structural changes, but MUST allow the user to explicitly opt out and proceed directly with implementation or lightweight decision reports without blocking file mutations.
- **[RF-04] Universal Subagent Delegation:** Regardless of whether `openspec/` exists, `rules/AGENTS.md` MUST prohibit chaining `view_file`, `grep_search`, or `find_by_name` in the main session for broad codebase impact mapping, requiring delegation to `sdd-code-explorer` (or native `research`) to prevent context bloat.
- **[RF-05] Root Documentation:** The repository root MUST contain a `README.md` documenting global installation (`agy plugin install .`), Dual-Mode Governance behavior, and the complete inventory of bundled skills, subagents, and hooks.

## Non-Functional Requirements

- **[RNF-01] Rule Token Budget:** `rules/AGENTS.md` MUST NOT exceed `55` lines so that always-on global rule injection remains lightweight across all sessions.
- **[RNF-02] Backward-Compatible Artifact Identifiers:** Existing `sdd-*` skill names and `sdd-*` subagent names MUST remain unchanged to preserve compatibility with existing `openspec/` workflows and prompts.

## Out of Scope

- Per-repository automatic creation of `openspec/` without explicit user confirmation via `sdd-init`.
- Hard-blocking file writes in workspaces that do not contain an `openspec/` directory.

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-11-13 | @allysson-assuncao | Initial draft for `agentic-dev-workflow` v4.0.0 Dual-Mode Governance |
