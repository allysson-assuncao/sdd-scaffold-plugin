# Specification: SDD Prompt Architect Agent

> **Spec ID:** `spec-agent-sdd-prompt-architect`
> **Title:** SDD Prompt Architect Subagent
> **Version:** 1.2.0
> **Status:** active
> **Owners:** @sdd-team
> **Scope:** Defines configuration, frontmatter metadata, tooling constraints, and execution boundaries for the `sdd-prompt-architect` subagent.
>
> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from openspec/changes/.

---

## 1. Specification Overview

Defines the configuration, frontmatter metadata, tooling constraints, and execution boundaries for the `sdd-prompt-architect` subagent in `sdd-scaffold-plugin`.

## 2. Frontmatter Contract

```yaml
name: sdd-prompt-architect
description: >-
  Lightweight subagent that generates structured prompt files for heavier execution
  models. Inspects project state (openspec/changes/, git status) to choose among four
  templates and writes prompt-*.md in the project root. Never dispatches executors.
  Invoke via the sdd-prompt-craft skill.
tools:
  - read_file
  - grep_search
  - find_by_name
  - list_dir
  - write_file
  - invoke_subagent
  - send_message
subagent: true
mainAgent: false
model: flash
commandExecutionPolicy: sandbox
```

## 3. Operational Requirements

- **Model Tier:** Bounded strictly to `flash` for low token consumption and fast response times.
- **Tooling Restrictions:** Read tools (`read_file`, `grep_search`, `find_by_name`, `list_dir`), scoped write tools (`write_file`), and subagent coordination tools (`invoke_subagent`, `send_message`). Legacy aliases (`view_file`, `write_to_file`) are strictly omitted to prevent duplicate tool resolution conflicts in the Antigravity runtime. Prohibited tool: `run_command` is strictly excluded.
- **Execution Sandbox:** Execution policy is set to `sandbox`.
- **Target Path Enforcement:** Allowed write target is exclusively `prompt-*.md` or `prompt.md` in the project root. Any path containing subdirectories or deviating from this pattern must be rejected.
- **Subagent Delegation:** Only read-only mapping subagents (such as `sdd-code-explorer`) may be invoked. The subagent must never invoke execution agents or dispatch the generated prompt.

## 4. Acceptance Criteria (Given-When-Then)

- **Scenario 1: Path containment**
  - **Given** a write target path outside the project root (e.g., `src/prompt.md` or `openspec/prompt.md`),
  - **When** `sdd-prompt-architect` evaluates the target path,
  - **Then** the write operation is rejected.

- **Scenario 2: Read-only scanning delegation**
  - **Given** an intent requiring repository symbol or file mapping,
  - **When** `sdd-prompt-architect` requires repository structure information,
  - **Then** it delegates the scan to `sdd-code-explorer` rather than performing broad manual file traversals.

- **Scenario 3: Non-dispatch guarantee**
  - **Given** a successfully generated prompt file,
  - **When** `sdd-prompt-architect` completes writing to disk,
  - **Then** it responds with a clickable markdown link in pt-BR and stops without invoking an execution agent.

## 5. Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-10-07 | @sdd-team | Initial specification (`feat-sdd-prompt-architect`) |
| 1.1.0 | 2026-11-05 | @allysson-assuncao | Add `read_file`, `list_dir`, `write_file`, and `send_message` to `tools:` allowlist (`feat-hooks-and-readonly-permissions`) |
| 1.2.0 | 2026-11-08 | @antigravity | Remove redundant aliases `view_file` and `write_to_file` to fix executor tool conflict (`fix-subagent-tool-conflicts-and-resource-paths`) |
