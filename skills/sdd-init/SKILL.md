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
