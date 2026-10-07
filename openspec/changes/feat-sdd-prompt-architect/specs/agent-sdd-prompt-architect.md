# Delta Spec: `agents/sdd-prompt-architect.md`

> **Change ID:** `feat-sdd-prompt-architect`
> **File:** `agents/sdd-prompt-architect.md`
> **Change Type:** Create

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
  - view_file
  - grep_search
  - find_by_name
  - write_to_file
  - invoke_subagent
subagent: true
mainAgent: false
model: flash
commandExecutionPolicy: sandbox
```

## 3. Operational Requirements

- **Model Tier:** Bounded strictly to `flash` for low token consumption and fast response times.
- **Tooling Restrictions:** Read tools (`view_file`, `grep_search`, `find_by_name`), `write_to_file`, and `invoke_subagent`. Prohibited tool: `run_command` is strictly excluded.
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
