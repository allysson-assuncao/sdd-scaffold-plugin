# sdd-scaffold-plugin v2 — Full Rebuild Implementation Plan (Verbatim Edition)

## Overview

This plan is a **deterministic, self-contained execution blueprint** for the ground-up reconstruction of the `sdd-scaffold-plugin`. Every single file to be created is specified with its **exact, verbatim content**. The executor agent must write files exactly as shown — no interpretation, no creative rewriting, no additions beyond what is specified.

**Plugin identity:**
- Name: `sdd-scaffold-plugin`
- Type: Global, stack-agnostic Antigravity 2.0 plugin
- Purpose: Scaffold provisioner for Spec-Driven Development (SDD) workflows
- Published at: repository root (`c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/`)
- Registered globally via: `~/.gemini/config/plugins.json` (out of scope for this plan)

---

## Repository Status

> [!NOTE]
> The repository (`sdd-scaffold-plugin`) currently contains only `.git`, `LICENSE`, and `prompt.md`. **No legacy files to delete.** Phase 0 is a no-op. Do NOT delete `LICENSE` or `prompt.md`.

---

## Complete File Tree to Be Created

```text
sdd-scaffold-plugin/                              (repository root — already exists)
├── plugin.json                                   [NEW] — 6 lines
├── hooks.json                                    [NEW] — 1 line
├── rules/
│   └── AGENTS.md                                 [NEW] — ≤ 50 lines
├── agents/
│   └── sdd-code-explorer.md                      [NEW] — ~30 lines
└── skills/
    ├── sdd-init/
    │   ├── SKILL.md                              [NEW]
    │   └── resources/
    │       ├── sdd-stack-contract.md             [NEW] template
    │       ├── openspec-proposal.md              [NEW] template
    │       ├── openspec-tasks.md                 [NEW] template
    │       └── spec-template.md                  [NEW] template
    ├── sdd-spec-create/
    │   ├── SKILL.md                              [NEW]
    │   └── resources/
    │       └── proposal-template.md              [NEW] template
    ├── sdd-spec-archive/
    │   └── SKILL.md                              [NEW]
    └── sdd-skill-creator/
        ├── SKILL.md                              [NEW]
        └── resources/
            ├── skill-template.md                [NEW] template
            └── agent-template.md                [NEW] template
```

**Total: 16 new files across 10 directories.**

---

## Execution Rules for the Executor Agent

1. Create files **sequentially** in Phase order (Phase 1 → Phase 2).
2. Write file contents **verbatim** as shown in the code blocks below. Do not paraphrase, summarize, or reformat.
3. **Do not** create any files not listed in this plan.
4. **Do not** delete `LICENSE` or `prompt.md`.
5. If any ambiguity is encountered, STOP and ask before proceeding.
6. After all files are created, run the Phase 3 validation commands exactly as specified.

---

## Phase 0 — Cleanup

> [!NOTE]
> No action required. Repository is already clean.

---

## Phase 1 — Core Infrastructure Files

Create these 4 files first, in order.

---

### 1.1 — `plugin.json`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/plugin.json`

```json
{
  "$schema": "https://antigravity.google/schemas/v1/plugin.json",
  "name": "sdd-scaffold-plugin",
  "description": "Universal SDD scaffold plugin for Antigravity 2.0. Provisions openspec/ lifecycle, conventions, and skills for spec-driven agent development in any repository."
}
```

> [!NOTE]
> Do NOT attempt to validate the `$schema` URL online. It is a purely declarative field recognized by the Antigravity runtime — it is not a live URL to be fetched.

---

### 1.2 — `hooks.json`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/hooks.json`

```json
{}
```

> [!NOTE]
> Must be a valid JSON empty object `{}`, NOT an empty file and NOT `null`. This serves as an extensibility entry-point; no hooks are active at this stage.

---

### 1.3 — `rules/AGENTS.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/rules/AGENTS.md`

> [!IMPORTANT]
> This is the only always-on rule in the plugin. It must be ≤ 50 lines. Do NOT add YAML frontmatter — standalone `AGENTS.md` files do not use frontmatter per official spec. They are unconditionally active for all directories at and below the plugin root.

```markdown
# SDD Conventions — sdd-scaffold-plugin

## Spec-First Mandate
Before performing any structural code change (adding, renaming, or deleting files, APIs, or data models), you MUST:
1. Check whether an active spec already exists in `openspec/changes/` for the intended change.
2. If none exists, activate the `sdd-spec-create` skill to create one.
3. Do NOT begin implementation until a `proposal.md` has been reviewed and approved by the user.

## Namespace Separation
- `.agents/` — Agent configuration only: rules, subagents, skills, MCP configs.
- `openspec/` — Business specifications only: proposals, tasks, specs, archive.
- Never mix agent config files into `openspec/`, and never store business specs inside `.agents/`.

## Code Scanning
- For any spec that requires mapping impacted files, methods, or routes, invoke the `sdd-code-explorer` subagent.
- Prefer `sdd-code-explorer` for targeted file-tree and symbol lookups; use the native `research` subagent for broader cross-cutting questions.

## Progressive Disclosure
- Never inline the full content of a skill into your response. Activate skills on demand.
- When referencing a spec or task file, read it; do not guess its contents.

## Version Control
- ALL files created inside `.agents/` and `openspec/` MUST be committed to Git.
- Never write runtime caches, indexes, or ephemeral outputs into these directories.

## Archival Gate
- A change may only be archived via `sdd-spec-archive` after ALL tasks in `tasks.md` are marked `[x]`.
- Incomplete tasks block archival unconditionally.

## Anti-Patterns (DO NOT)
- DO NOT place business specs (proposal.md, tasks.md) inside `.agents/`.
- DO NOT place agent configs (SKILL.md, AGENTS.md, agent definitions) inside `openspec/`.
- DO NOT inline the full body of a skill or spec file into a chat response.
- DO NOT modify `openspec/specs/` directly — always go through `openspec/changes/`.
- DO NOT commit runtime caches or engine indexes (e.g., `.antigravity/`) to Git.
```

---

### 1.4 — `agents/sdd-code-explorer.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/agents/sdd-code-explorer.md`

> [!IMPORTANT]
> The YAML frontmatter block MUST be the very first thing in the file — starting at line 1 with `---` and closing with `---` before any Markdown body. All frontmatter keys are required.

```markdown
---
name: sdd-code-explorer
description: >-
  Subagent specialized in scanning the source repository and mapping file paths,
  methods, and routes affected by a given specification. Invoke this subagent
  when a code-impact analysis is needed before writing a proposal or task list.
  Returns a structured report of impacted files, symbols, and suggested spec stubs.
tools:
  - view_file
  - grep_search
  - find_by_name
subagent: true
mainAgent: false
model: flash
commandExecutionPolicy: sandbox
---

# sdd-code-explorer

You are a read-only code scanning subagent. Your sole responsibility is to map the repository structure and identify files, classes, methods, and routes that are relevant to the specification or change described in your task prompt.

## Input

You will receive a task prompt describing:
- A feature, change, or specification summary.
- Optionally, specific symbols, file globs, or directories to focus on.

## Output

Return a structured Markdown report with the following sections:

### Impacted Files
List every file path that is directly or likely affected by the described change. For each file, include a one-line reason.

### Impacted Symbols
List methods, classes, interfaces, or route handlers that are touched by the change. Include the file path and approximate line number if found.

### Suggested Spec Stubs
For each impacted file, suggest a `specs/<filename>-delta.md` stub filename to be created under the active change directory.

## Constraints
- You MUST operate in read-only mode at all times.
- Do NOT write, create, edit, move, or delete any file.
- Do NOT execute shell commands.
- Do NOT hallucinate file contents. Only report what you can verify by reading actual files.
- If a file or symbol is not found, say so explicitly — do not guess.
```

---

## Phase 2 — Skills and Resources

Create skills in order: `sdd-init` → `sdd-spec-create` → `sdd-spec-archive` → `sdd-skill-creator`.
For each skill, create the `SKILL.md` first, then its `resources/` files.

---

### 2.1 — Skill: `sdd-init`

#### 2.1.1 — `skills/sdd-init/SKILL.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-init/SKILL.md`

```markdown
---
name: sdd-init
description: >-
  Use this skill to initialize a new or existing software project with the full
  SDD (Spec-Driven Development) scaffold. Creates the .agents/ directory
  structure and the openspec/ documentation namespace, and seeds both with
  example templates. Activate when the user asks to 'set up SDD', 'initialize
  SDD in this repo', 'scaffold my project', or 'run sdd-init'.
---

# sdd-init — Initialize SDD Scaffold

## Purpose
Provision the standard SDD directory structure and seed templates into the target workspace so the team can immediately begin creating specifications.

## Prerequisites
- You must know the **absolute path to the target workspace root** before beginning. If unsure, ask the user.
- Confirm: "I am about to create `.agents/` and `openspec/` inside `<workspace-path>`. Proceed?"

## Step 1 — Safety Check
Before creating any directory, check whether `.agents/` or `openspec/` already exist in the workspace root.

- If **neither exists**: proceed without prompting.
- If **either exists**: STOP. Warn the user: "Directory `<name>/` already exists. Initializing again may overwrite existing configuration. Confirm to proceed (yes/no)?" Do not proceed until the user explicitly confirms.

## Step 2 — Executive Summary & Confirmation

Before creating any directories or files, display the following execution plan and request explicit confirmation from the user:

```
📋 SDD Scaffold — Execution Plan

Workspace: <workspace-root>

Directories to create:
  .agents/
  .agents/rules/
  .agents/agents/
  .agents/skills/
  openspec/
  openspec/specs/
  openspec/changes/
  openspec/archive/
  openspec/changes/_example/
  openspec/changes/_example/specs/

Files to seed:
  openspec/specs/sdd-stack-contract.md
  openspec/specs/_template.md
  openspec/changes/_example/proposal.md
  openspec/changes/_example/tasks.md

Confirm? (yes / no)
```

Do NOT proceed to Step 3 until the user explicitly confirms with "yes". If the user says "no", STOP and ask what they would like to change.

## Step 3 — Create Agent Configuration Namespace (`.agents/`)

Create the following directories (create parent directories as needed):

```
<workspace-root>/.agents/
<workspace-root>/.agents/rules/
<workspace-root>/.agents/agents/
<workspace-root>/.agents/skills/
```

No files are created inside `.agents/` at this stage. The directories serve as mount points for future workspace-level customizations.

## Step 4 — Create Specification Namespace (`openspec/`)

Create the following directories:

```
<workspace-root>/openspec/
<workspace-root>/openspec/specs/
<workspace-root>/openspec/changes/
<workspace-root>/openspec/archive/
<workspace-root>/openspec/changes/_example/
<workspace-root>/openspec/changes/_example/specs/
```

## Step 5 — Seed Templates

Copy the following template files from this skill's `resources/` directory into the workspace. Read each resource file and write its contents to the destination path:

| Source (relative to this SKILL.md) | Destination (relative to workspace root) |
|---|---|
| `resources/sdd-stack-contract.md` | `openspec/specs/sdd-stack-contract.md` |
| `resources/spec-template.md` | `openspec/specs/_template.md` |
| `resources/openspec-proposal.md` | `openspec/changes/_example/proposal.md` |
| `resources/openspec-tasks.md` | `openspec/changes/_example/tasks.md` |

## Step 6 — Confirm

After all directories and files are created, output a confirmation summary:

```
✅ SDD scaffold initialized at <workspace-root>

Created directories:
  .agents/
  .agents/rules/
  .agents/agents/
  .agents/skills/
  openspec/
  openspec/specs/
  openspec/changes/
  openspec/archive/
  openspec/changes/_example/
  openspec/changes/_example/specs/

Seeded templates:
  openspec/specs/sdd-stack-contract.md
  openspec/specs/_template.md
  openspec/changes/_example/proposal.md
  openspec/changes/_example/tasks.md

Next step: Use the sdd-spec-create skill to open your first change proposal.
```

## Notes
- Do NOT create a `plugins.json` or `.gemini/` directory inside the workspace. Those belong to the global config.
- Do NOT modify any existing files in the workspace.
- The `_example` change is illustrative only. The user should not implement it — they should rename or delete it when creating their first real change.
```

---

#### 2.1.2 — `skills/sdd-init/resources/sdd-stack-contract.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-init/resources/sdd-stack-contract.md`

```markdown
# SDD Stack Contract

> This file declares the technology stack and architectural constraints of this project.
> It is read by skills and subagents to make stack-aware decisions.
> Fill in each section and commit this file to version control.

---

## Stack Identity

- **Project Name:** <!-- e.g. my-api-service -->
- **Primary Language:** <!-- e.g. TypeScript, Python, Go, Java -->
- **Runtime / Platform:** <!-- e.g. Node.js 20, Python 3.12, JVM 21 -->
- **Framework:** <!-- e.g. NestJS, FastAPI, Spring Boot, Next.js -->
- **Package Manager:** <!-- e.g. npm, pnpm, poetry, gradle -->

---

## Project Structure

- **Source Root:** <!-- e.g. src/ -->
- **Test Root:** <!-- e.g. src/__tests__/, tests/ -->
- **Entry Point:** <!-- e.g. src/main.ts, app/main.py -->
- **Build Output:** <!-- e.g. dist/, build/ -->

---

## Test Runner

- **Command:** <!-- e.g. npm test, pytest, ./gradlew test -->
- **Test Framework:** <!-- e.g. Jest, Pytest, JUnit -->
- **Coverage Command:** <!-- e.g. npm run test:coverage -->

---

## Code Style

- **Linter:** <!-- e.g. ESLint, Ruff, Checkstyle -->
- **Formatter:** <!-- e.g. Prettier, Black, google-java-format -->
- **Format Command:** <!-- e.g. npm run format -->

---

## API Contract (if applicable)

- **API Type:** <!-- e.g. REST, GraphQL, gRPC -->
- **Spec Location:** <!-- e.g. openapi/openapi.yaml, schema.graphql -->
- **Base URL (dev):** <!-- e.g. http://localhost:3000 -->

---

## Database (if applicable)

- **Engine:** <!-- e.g. PostgreSQL 15, MongoDB, SQLite -->
- **Migration Tool:** <!-- e.g. Alembic, Flyway, Prisma Migrate -->
- **Migration Command:** <!-- e.g. alembic upgrade head -->

---

## Notes

<!-- Any additional constraints, conventions, or decisions the agent should be aware of. -->
```

---

#### 2.1.3 — `skills/sdd-init/resources/openspec-proposal.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-init/resources/openspec-proposal.md`

```markdown
# Proposal: [Change Title]

> **Change ID:** `_example`
> **Status:** draft | under-review | approved | rejected
> **Author:** <!-- your name or @handle -->
> **Created:** <!-- YYYY-MM-DD -->
> **Last Updated:** <!-- YYYY-MM-DD -->

---

## Summary

<!-- One paragraph describing what this change does and why it is needed. -->

## Motivation

<!-- What problem does this solve? What user need or business requirement drives it?
     Include links to issues, tickets, or discussions if applicable. -->

## Scope

### In Scope
- <!-- Bullet list of what IS included in this change -->

### Out of Scope
- <!-- Bullet list of what is explicitly NOT included -->

## Proposed Solution

<!-- Describe the approach at a high level. Reference impacted files if known.
     Use the sdd-code-explorer subagent to populate this section if needed. -->

## Acceptance Criteria

<!-- Written as Given-When-Then or as verifiable checkboxes: -->
- [ ] <!-- Criterion 1 -->
- [ ] <!-- Criterion 2 -->

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| <!-- risk --> | Low/Med/High | Low/Med/High | <!-- mitigation --> |

## References

- <!-- Links to related specs, ADRs, or documentation -->
```

---

#### 2.1.4 — `skills/sdd-init/resources/openspec-tasks.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-init/resources/openspec-tasks.md`

```markdown
# Tasks: [Change Title]

> **Change ID:** `_example`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress | complete
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [ ] <!-- Task 1: short imperative description, e.g. "Create UserAuthService class" -->
- [ ] <!-- Task 2 -->
- [ ] <!-- Task 3 -->

## Test Tasks

- [ ] <!-- e.g. "Write unit tests for UserAuthService.login()" -->
- [ ] <!-- e.g. "Write integration test for POST /auth/login endpoint" -->

## Documentation Tasks

- [ ] <!-- e.g. "Update openapi.yaml with /auth/login schema" -->
- [ ] <!-- e.g. "Update README with auth setup instructions" -->

## Review Gate

- [ ] All implementation tasks complete
- [ ] All tests passing (`<test command>`)
- [ ] Proposal acceptance criteria verified
- [ ] Ready for `sdd-spec-archive`
```

---

### 2.1.5 — `skills/sdd-init/resources/spec-template.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-init/resources/spec-template.md`

```markdown
---
id: "<spec-id>"
title: "<Readable Title of This Living Specification>"
version: "1.0.0"
status: "draft"
owners:
  - "<!-- @handle or team name -->"
scope:
  paths:
    - "<!-- e.g. src/module/** -->"
resources: []
---

# <Spec Title> — Living Specification

> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from `openspec/changes/`.

---

## Context & Objectives

<!-- One paragraph describing the domain, the problem this module solves, and its long-term goals. -->

## Functional Requirements

- **[RF-01]** <!-- Description of functional requirement 1. -->
- **[RF-02]** <!-- Description of functional requirement 2. -->

## Non-Functional Requirements

- **[RNF-01]** <!-- e.g. Response time < 200ms at p99 load. -->

## Out of Scope

<!-- List items that are explicitly NOT governed by this spec. -->

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | <!-- YYYY-MM-DD --> | <!-- @handle --> | Initial draft |
```

---

### 2.2 — Skill: `sdd-spec-create`

#### 2.2.1 — `skills/sdd-spec-create/SKILL.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-spec-create/SKILL.md`

```markdown
---
name: sdd-spec-create
description: >-
  Use this skill to create a new isolated change proposal inside openspec/changes/.
  Scaffolds the change directory with proposal.md, tasks.md, and a specs/ subfolder.
  Optionally invokes sdd-code-explorer to map impacted files. Activate when the user
  wants to 'create a spec', 'write a proposal', 'open a new change', 'start a new
  feature spec', or 'plan a change'.
---

# sdd-spec-create — Create a Change Proposal

## Purpose
Open a new, isolated change directory under `openspec/changes/<change-id>/` containing a structured proposal and task checklist, ready for review and implementation.

## Prerequisites
- `openspec/changes/` must exist. If it does not, instruct the user to run `sdd-init` first and STOP.
- You must have a **change ID** before creating any files.

## Step 1 — Gather Change ID

Ask the user for a `<change-id>` if not already provided.

Rules for change IDs:
- Must be **kebab-case** (lowercase letters, numbers, hyphens only).
- Must be **descriptive and unique** (e.g., `add-user-auth`, `refactor-payment-module`, `fix-order-status-bug`).
- Must NOT start with a number or underscore.
- Must NOT contain spaces or special characters.

If the user provides a name that violates these rules, suggest a corrected version and ask for confirmation.

Check that `openspec/changes/<change-id>/` does NOT already exist. If it does, STOP and warn: "A change with ID `<change-id>` already exists. Choose a different ID or open the existing change."

## Step 2 — Executive Summary & Confirmation

Before creating any directories or files, display the following execution plan and request explicit confirmation from the user:

```
📋 New Change Proposal — Execution Plan

Change ID:  <change-id>
Workspace:  <workspace-root>

Directories to create:
  openspec/changes/<change-id>/
  openspec/changes/<change-id>/specs/

Files to create:
  openspec/changes/<change-id>/proposal.md  (populated from proposal-template.md)
  openspec/changes/<change-id>/tasks.md     (fresh task checklist)

Confirm? (yes / no)
```

Do NOT proceed to Step 3 until the user explicitly confirms with "yes". If the user says "no", STOP and ask what they would like to change.

## Step 3 — Scaffold Change Directory

Create the following directories and files:

**Directories:**
```
openspec/changes/<change-id>/
openspec/changes/<change-id>/specs/
```

**Files:**

`openspec/changes/<change-id>/proposal.md` — Populate using `resources/proposal-template.md` as the base. Replace the placeholder `[Change Title]` with a human-readable version of the change ID (e.g., `add-user-auth` → "Add User Auth"). Set `Change ID` to `<change-id>` and `Created` to today's date (ISO 8601: YYYY-MM-DD).

`openspec/changes/<change-id>/tasks.md` — Create with this exact content (substituting `<change-id>` and `<change-title>`):

```markdown
# Tasks: <change-title>

> **Change ID:** `<change-id>`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** in-progress
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [ ] <!-- Add implementation tasks here -->

## Test Tasks

- [ ] <!-- Add test tasks here -->

## Documentation Tasks

- [ ] <!-- Add documentation tasks here -->

## Review Gate

- [ ] All implementation tasks complete
- [ ] All tests passing
- [ ] Proposal acceptance criteria verified
- [ ] Ready for `sdd-spec-archive`
```

## Step 4 — Optional: Code Impact Analysis

Ask the user: "Would you like me to scan the codebase for files and symbols likely impacted by this change? (yes/no)"

- If **yes**: Invoke the `sdd-code-explorer` subagent (or the native `research` subagent if `sdd-code-explorer` is unavailable) with the proposal summary as the task prompt. Use the returned report to:
  1. Populate the "Proposed Solution" section of `proposal.md` with the list of impacted files.
  2. Create stub files in `openspec/changes/<change-id>/specs/` named `<filename>-delta.md` for each impacted file, using the format shown in `resources/proposal-template.md`.
- If **no**: Skip this step.

## Step 5 — Confirm

Output a confirmation summary:

```
✅ Change `<change-id>` created.

Files created:
  openspec/changes/<change-id>/proposal.md
  openspec/changes/<change-id>/tasks.md
  openspec/changes/<change-id>/specs/  (empty, ready for delta specs)

Next steps:
  1. Fill in the proposal: openspec/changes/<change-id>/proposal.md
  2. Get user approval on the proposal before beginning implementation.
  3. Add tasks to: openspec/changes/<change-id>/tasks.md
  4. When all tasks are complete, run sdd-spec-archive to close the change.
```

## Notes
- Do NOT start implementing the change. This skill only creates the specification scaffold.
- The proposal MUST be reviewed and approved by the user before any code is written.
- Delta spec stubs in `specs/` are optional scaffolding — they can be created/deleted freely.
```

---

#### 2.2.2 — `skills/sdd-spec-create/resources/proposal-template.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-spec-create/resources/proposal-template.md`

```markdown
# Proposal: [Change Title]

> **Change ID:** `<change-id>`
> **Status:** draft
> **Author:** <!-- @handle or full name -->
> **Created:** YYYY-MM-DD
> **Last Updated:** YYYY-MM-DD

---

## Summary

<!-- One paragraph. What does this change do? Why is it needed?
     Be specific enough that a reviewer who doesn't know the context can understand. -->

## Motivation

<!-- What problem does this solve?
     - Reference user pain points, bug reports, or product requirements.
     - Include links to issues, tickets, Slack threads, or ADRs if applicable. -->

## Scope

### In Scope
- <!-- List every deliverable explicitly included in this change. -->

### Out of Scope
- <!-- List items that might seem related but are NOT part of this change. -->
  <!-- Being explicit here prevents scope creep during implementation. -->

## Proposed Solution

### Approach
<!-- Describe the technical approach in 2-4 paragraphs.
     Cover: what will be created/modified/deleted, why this approach was chosen,
     and any significant trade-offs. -->

### Impacted Files
<!-- List files identified by sdd-code-explorer or manual analysis. -->
| File | Change Type | Notes |
|------|-------------|-------|
| `path/to/file.ts` | Modify | <!-- brief note --> |
| `path/to/new-file.ts` | Create | <!-- brief note --> |

### Data Model Changes (if applicable)
<!-- Describe any changes to database schemas, API contracts, or shared types. -->

## Acceptance Criteria

<!-- Written as verifiable conditions. Each criterion must be testable. -->
- [ ] **Given** <!-- context --> **When** <!-- action --> **Then** <!-- expected result -->
- [ ] <!-- Criterion 2 -->
- [ ] <!-- Criterion 3 -->

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| <!-- Describe risk --> | Low / Med / High | Low / Med / High | <!-- How to mitigate --> |

## Delta Spec Stubs

<!-- One section per impacted file. The sdd-code-explorer subagent can generate these. -->

### `specs/<filename>-delta.md`
<!-- What changes in this file specifically. Include: function signatures,
     new types, removed fields, new endpoints, etc. -->

## References

- <!-- Link to related spec, ADR, or documentation -->
- <!-- Link to issue tracker ticket -->
```

---

### 2.3 — Skill: `sdd-spec-archive`

#### 2.3.1 — `skills/sdd-spec-archive/SKILL.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-spec-archive/SKILL.md`

```markdown
---
name: sdd-spec-archive
description: >-
  Use this skill to validate, merge, and archive a completed SDD change. Reads
  tasks.md to verify all tasks are done, merges delta specs from openspec/changes/
  into openspec/specs/, then moves the change to openspec/archive/. Activate when
  the user asks to 'archive a spec', 'close a change', 'merge and archive <change-id>',
  or 'mark this change as done'.
---

# sdd-spec-archive — Validate, Merge & Archive a Change

## Purpose
Close out a completed change by verifying its task checklist, merging its delta specs into the canonical spec directory, and archiving the change folder with a timestamp.

## Prerequisites
- `openspec/changes/<change-id>/` must exist.
- `openspec/specs/` must exist.
- `openspec/archive/` must exist.

If any of these are missing, STOP and instruct the user to run `sdd-init` first.

## Step 1 — Identify the Change

Ask the user for the `<change-id>` to archive if not provided in the prompt.

Verify that the directory `openspec/changes/<change-id>/` exists. If not, STOP: "No active change found with ID `<change-id>`. Check `openspec/changes/` for available changes."

## Step 2 — Task Completeness Gate (HARD BLOCK)

> [!IMPORTANT]
> This is an unconditional hard gate. It CANNOT be bypassed under any circumstance,
> even if the user asks you to skip it.

Read `openspec/changes/<change-id>/tasks.md`.

Parse every line that matches the pattern `- [ ]` (unchecked task) or `- [x]` (checked task).

**If ANY unchecked tasks (`- [ ]`) are found:**
- STOP immediately.
- List all unchecked tasks in your response.
- Output: "❌ Archive blocked. The following tasks are not yet complete: [list]. Complete all tasks before archiving."
- Do NOT proceed to Step 3.

**Only if ALL tasks are `[x]`:** proceed to Step 3.

## Step 3 — Merge Delta Specs

Read all files inside `openspec/changes/<change-id>/specs/`.

For each file in `specs/`:
1. Determine the destination path: `openspec/specs/<filename>`.
2. Check if the destination file already exists in `openspec/specs/`.
   - If it **does NOT exist**: write the file to `openspec/specs/<filename>`.
   - If it **exists**: warn the user: "File `openspec/specs/<filename>` already exists and will be overwritten. Confirm? (yes/no)". Only overwrite after explicit user confirmation.
3. Write the file to `openspec/specs/<filename>`.

If `openspec/changes/<change-id>/specs/` is empty, skip this step (no files to merge).

## Step 4 — Archive the Change Directory

Determine the archive timestamp using the current UTC date and time in format `YYYYMMDDTHHMMSSZ` (e.g., `20260923T164512Z`).

Construct the archive path: `openspec/archive/<timestamp>-<change-id>/`

Move the entire directory `openspec/changes/<change-id>/` to `openspec/archive/<timestamp>-<change-id>/`.

This includes `proposal.md`, `tasks.md`, and the `specs/` subdirectory (now emptied into `openspec/specs/`).

## Step 5 — Confirm

Output a confirmation summary:

```
✅ Change `<change-id>` archived successfully.

Merged specs (N files):
  openspec/specs/<file1>
  openspec/specs/<file2>
  ...

Archived to:
  openspec/archive/<timestamp>-<change-id>/

The change is now closed. Its proposal and tasks are preserved in the archive.
```

## Notes
- The archive is permanent within the `openspec/` namespace. The user can always find historical changes in `openspec/archive/`.
- Do NOT delete the archive directory after creation.
- Do NOT modify `openspec/specs/` files that were NOT part of this change's delta specs.
```

---

### 2.4 — Skill: `sdd-skill-creator`

#### 2.4.1 — `skills/sdd-skill-creator/SKILL.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-skill-creator/SKILL.md`

```markdown
---
name: sdd-skill-creator
description: >-
  Use this skill to guide the creation of new Antigravity 2.0 Skills or Rules
  within a workspace or global configuration. Scaffolds the skill directory,
  populates SKILL.md with valid frontmatter, and reminds the user of best
  practices. Activate when the user wants to 'create a new skill', 'add a rule',
  'write a custom skill', 'scaffold a new agent skill', or 'make a workflow skill'.
---

# sdd-skill-creator — Create a New Skill or Rule

## Purpose
Guide the user through creating a well-formed Antigravity 2.0 skill or rule that follows official conventions, including valid YAML frontmatter, progressive disclosure structure, and correct placement.

## Step 1 — Determine What to Create

Ask the user: "What would you like to create?"
- **Option A: Skill** — A multi-step procedural guide stored in `skills/<name>/SKILL.md`.
- **Option B: Rule (AGENTS.md)** — An always-on directive stored as `rules/AGENTS.md` or directly as `AGENTS.md` in a directory.
- **Option C: Subagent** — A specialized read-only or task-scoped subagent stored as `agents/<name>.md`.

If the user chooses **Option B (Rule)**, skip to the Rule Creation section below.
If the user chooses **Option C (Subagent)**, skip to the Subagent Creation section below.

## Step 2 — Gather Skill Metadata (Skills only)

Ask the user for the following, one question at a time:

1. **Skill name**: Must be kebab-case (e.g., `deploy-to-staging`, `run-e2e-tests`). Must start with a letter.
2. **Short description**: 1-3 sentences in third person. Explain what the skill does and when it should be activated. This text becomes the `description` frontmatter field — it is what the main agent reads to decide whether to activate the skill.
3. **Target location**: Where should the skill live?
   - `workspace` — inside the current project's `.agents/skills/<skill-name>/` (shared via VCS).
   - `global` — inside `~/.gemini/config/skills/<skill-name>/` (machine-local, all projects).

## Step 3 — Resolve Target Path

Based on the chosen location:
- **workspace**: `<workspace-root>/.agents/skills/<skill-name>/`
- **global**: `~/.gemini/config/skills/<skill-name>/` (expand `~` to the actual home directory)

Check that this directory does NOT already exist. If it does, STOP: "A skill named `<skill-name>` already exists at `<path>`. Choose a different name or edit the existing skill."

## Step 4 — Scaffold the Skill

Create the directory: `<target-path>/`

Create `<target-path>/SKILL.md` by reading `resources/skill-template.md` and substituting:
- `{{SKILL_NAME}}` → the skill name provided by the user.
- `{{SKILL_DESCRIPTION}}` → the description provided by the user (preserve line breaks in the YAML block scalar).

Ask the user: "Does this skill need resource files (templates, reference docs, scripts)?"
- If **yes**: Create `<target-path>/resources/` directory and inform the user they can add files there.
- If **no**: Skip.

## Step 5 — Remind User of Best Practices

Output the following reminder:

```
📋 Skill Best Practices (Antigravity 2.0)

1. Keep SKILL.md under 500 lines / ~5,000 tokens.
   Move heavy reference tables, schemas, or examples to resources/.

2. The `description` frontmatter is critical — the main agent uses it to
   decide whether to activate your skill. Make it specific and trigger-phrase-rich.

3. Use relative links to reference resources: [template](./resources/template.md)

4. Include a Validation section in your SKILL.md so the agent can verify
   each step succeeded before proceeding.

5. Never duplicate general coding knowledge. Focus only on your unique workflow.
```

## Step 6 — Confirm

```
✅ Skill `<skill-name>` created at:
  <target-path>/SKILL.md

Open the file and fill in the step-by-step instructions.
```

---

## Rule Creation (Option B)

If the user chose to create a **Rule**:

1. Ask: "Where should the rule apply?"
   - `workspace-global`: `<workspace-root>/.agents/rules/AGENTS.md` — applies to all files in the workspace.
   - `directory`: a specific directory path — creates `AGENTS.md` directly inside that directory.
   - `global`: `~/.gemini/config/rules/AGENTS.md` — applies to all workspaces on this machine.

2. Check if `AGENTS.md` already exists at the target path.
   - If yes: warn the user and ask whether to append or overwrite.
   - If no: create a new file.

3. Rules do NOT use YAML frontmatter. Write plain Markdown directly.

4. Remind the user: "Rules are always-on once placed. Keep them concise (ideally under 50 lines). Verbose rules consume the global 20,000-token rules budget."

5. Confirm: "✅ Rule file created/updated at `<path>`."

---

## Subagent Creation (Option C)

If the user chose to create a **Subagent**:

1. Ask the user for the following, one question at a time:
   - **Subagent name**: Must be kebab-case (e.g., `code-reviewer`, `test-runner`). Must start with a letter.
   - **Short description**: 1-3 sentences in third person. Describe the subagent's role and when the parent agent should invoke it.
   - **Tool set**: Which tools should this subagent use? Select from: `view_file`, `grep_search`, `find_by_name`, `run_command`, `write_to_file`, `replace_file_content`. For a read-only subagent, select only `view_file`, `grep_search`, `find_by_name`.
   - **Target location**: `workspace` (`.agents/agents/<name>.md`) or `global` (`~/.gemini/config/agents/<name>.md`).

2. Resolve the target path based on location choice.

3. Check that the file does NOT already exist. If it does, STOP: "A subagent named `<name>` already exists at `<path>`. Choose a different name or edit the existing subagent."

4. Create `<target-path>/<name>.md` by reading `resources/agent-template.md` and substituting:
   - `{{AGENT_NAME}}` → the subagent name.
   - `{{AGENT_DESCRIPTION}}` → the description provided by the user.
   - `{{AGENT_TOOLS}}` → the selected tool list formatted as a YAML sequence.

5. Remind the user:
   ```
   📋 Subagent Best Practices (Antigravity 2.0)

   1. Keep subagents narrowly scoped — one responsibility per subagent.
   2. Use `model: flash` for read-only or lightweight tasks to reduce cost.
   3. Set `commandExecutionPolicy: sandbox` if the subagent must not run shell commands.
   4. Always set `subagent: true` and `mainAgent: false` in the frontmatter.
   5. Never give a subagent more tools than it needs (principle of least privilege).
   ```

6. Confirm: "✅ Subagent `<name>` created at `<path>`."

## Notes
- Do NOT register the skill in `plugins.json` or `skills.json` automatically. Inform the user that workspace skills placed in `.agents/skills/` are auto-discovered.
- Do NOT modify any existing skill files other than the one being created.
```

---

#### 2.4.2 — `skills/sdd-skill-creator/resources/skill-template.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-skill-creator/resources/skill-template.md`

```markdown
---
name: {{SKILL_NAME}}
description: >-
  {{SKILL_DESCRIPTION}}
---

# {{SKILL_NAME}}

## Purpose
<!-- One paragraph describing what this skill accomplishes and why it exists. -->

## Prerequisites
<!-- List any conditions that must be true before this skill can run.
     e.g. - The workspace must have a package.json at the root.
           - The user must have provided a target environment name. -->

## Step 1 — [First Step Title]
<!-- Describe exactly what the agent should do in this step.
     Be imperative and precise. Include exact commands, file paths, or expected outputs. -->

### Validation
<!-- How does the agent verify this step succeeded? -->

## Step 2 — [Second Step Title]
<!-- ... -->

### Validation
<!-- ... -->

## Step N — [Final Step Title]
<!-- The last step should always include a confirmation output to the user. -->

### Confirmation Output
```
✅ [Summary of what was accomplished]

[List of created/modified artifacts]

Next step: [What the user should do next]
```

## Error Handling
<!-- What should the agent do if something goes wrong?
     - If X happens, STOP and report Y.
     - If Z is missing, ask the user for it. -->

## Notes
<!-- Any caveats, limitations, or important reminders. -->
<!-- Reference heavy resources using relative links: [resource](./resources/something.md) -->
```

---

### 2.4.3 — `skills/sdd-skill-creator/resources/agent-template.md`

**Path:** `c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin/skills/sdd-skill-creator/resources/agent-template.md`

```markdown
---
name: {{AGENT_NAME}}
description: >-
  {{AGENT_DESCRIPTION}}
tools:
{{AGENT_TOOLS}}
subagent: true
mainAgent: false
model: flash
commandExecutionPolicy: sandbox
---

# {{AGENT_NAME}}

You are a specialized subagent. Your sole responsibility is described in your task prompt.

## Constraints

- Operate only with the tools listed in your frontmatter.
- Do NOT hallucinate file contents. Only report what you can verify by reading actual files.
- If a file or symbol is not found, say so explicitly — do not guess.
- Return a concise, structured Markdown report to the parent agent upon completion.
```

---

## Phase 3 — Validation

After all 16 files are written, run the following validation checks **in order**. Each check must pass before moving to the next.

### Check 1 — Directory Tree

Run and compare output against the expected tree:

```powershell
Set-Location "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin"
Get-ChildItem -Recurse | Where-Object { $_.FullName -notmatch '\\\.git\\' } | Sort-Object FullName | Select-Object -ExpandProperty FullName
```

**Expected output must include exactly these paths (order may vary):**
```
...\agents\sdd-code-explorer.md
...\hooks.json
...\plugin.json
...\rules\AGENTS.md
...\skills\sdd-init\SKILL.md
...\skills\sdd-init\resources\openspec-proposal.md
...\skills\sdd-init\resources\openspec-tasks.md
...\skills\sdd-init\resources\sdd-stack-contract.md
...\skills\sdd-spec-archive\SKILL.md
...\skills\sdd-spec-create\SKILL.md
...\skills\sdd-spec-create\resources\proposal-template.md
...\skills\sdd-skill-creator\SKILL.md
...\skills\sdd-skill-creator\resources\skill-template.md
```

Plus the pre-existing: `LICENSE`, `prompt.md`.

### Check 2 — JSON Validity

```powershell
Get-Content "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin\plugin.json" | ConvertFrom-Json
Get-Content "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin\hooks.json" | ConvertFrom-Json
```

Both commands must complete without error.

### Check 3 — Rule File Size

```powershell
$lines = (Get-Content "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin\rules\AGENTS.md").Count
Write-Host "rules/AGENTS.md: $lines lines"
if ($lines -gt 50) { Write-Error "FAIL: rules/AGENTS.md exceeds 50 lines ($lines)" }
```

Must output a number ≤ 50.

### Check 4 — Subagent Frontmatter

```powershell
$content = Get-Content "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin\agents\sdd-code-explorer.md" -Raw
if ($content -notmatch '(?s)^---.*?subagent: true.*?---') {
  Write-Error "FAIL: sdd-code-explorer.md missing valid YAML frontmatter with subagent: true"
} else {
  Write-Host "PASS: sdd-code-explorer.md has valid frontmatter"
}
```

### Check 5 — All SKILL.md Files Have Valid Frontmatter

```powershell
Get-ChildItem "c:\Users\anybo\Documents\Projects\sdd-scaffold-plugin\skills" -Recurse -Filter "SKILL.md" | ForEach-Object {
  $text = Get-Content $_.FullName -Raw
  if ($text -notmatch '(?s)^---.*?name:.*?description:.*?---') {
    Write-Error "FAIL: $($_.FullName) — missing name or description in frontmatter"
  } else {
    $lines = (Get-Content $_.FullName).Count
    Write-Host "PASS: $($_.FullName) ($lines lines)"
    if ($lines -gt 500) { Write-Warning "WARNING: $($_.FullName) exceeds 500 lines ($lines)" }
  }
}
```

All SKILL.md files must output `PASS`. None should exceed 500 lines.

### Check 6 — Final Summary

If all checks pass, output:

```
✅ sdd-scaffold-plugin v2 — All validation checks passed.
   14 files created across 10 directories.
   Plugin is ready for global registration.
```

---

## Open Questions

None. All decisions are resolved. The executor agent must proceed without seeking further clarification unless it encounters an unexpected filesystem state.

---

## Post-Execution Note (Out of Scope)

To make this plugin globally active on this machine, the user (or a follow-up task) must add it to `~/.gemini/config/plugins.json`:

```json
{
  "plugins": [
    { "path": "c:/Users/anybo/Documents/Projects/sdd-scaffold-plugin" }
  ]
}
```

This step is **not** part of the current implementation plan and must NOT be executed by the executor agent unless explicitly instructed.
