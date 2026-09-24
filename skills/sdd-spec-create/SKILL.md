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
