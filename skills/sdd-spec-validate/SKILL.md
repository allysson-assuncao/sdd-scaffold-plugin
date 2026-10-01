---
name: sdd-spec-validate
description: >-
  Use this skill to run a pre-implementation audit of a change proposal before
  any code is written. Invokes the sdd-spec-auditor subagent to validate
  proposal.md and tasks.md completeness, Given-When-Then criteria, security
  considerations, and testing strategy. Issues an Approved, Approved with
  Reservations, or Rejected verdict. Activate when the user wants to 'validate
  a spec', 'audit a proposal', 'run pre-implementation check', or 'check if spec
  is ready'.
---

# sdd-spec-validate — Pre-Implementation Spec Audit

## Purpose
Run an automated audit of a change proposal and its task list before any implementation begins. The audit is performed by the `sdd-spec-auditor` subagent (read-only, sandboxed) to avoid context bloat. Implementation is blocked until the verdict is **Approved**.

## Prerequisites
- `openspec/changes/<change-id>/proposal.md` must exist.
- `openspec/changes/<change-id>/tasks.md` must exist.
- You must know the **workspace root path** and **change ID**.

## Step 1 — Identify the Change

Ask the user for the `<change-id>` to validate if not already provided.

Verify that `openspec/changes/<change-id>/proposal.md` exists. If not, STOP:
```
❌ Cannot validate: openspec/changes/<change-id>/proposal.md not found.
   Run sdd-spec-create to create the change proposal first.
```

## Step 2 — Invoke Auditor Subagent

Invoke the `sdd-spec-auditor` subagent via `invoke_subagent`:
- `TypeName`: `"sdd-spec-auditor"`
- `Role`: `"Spec Auditor for <change-id>"`
- `Prompt`: 
  ```
  Audit the change proposal for change ID: <change-id>
  Workspace root: <workspace-root>
  
  Read and audit:
  - openspec/changes/<change-id>/proposal.md
  - openspec/changes/<change-id>/tasks.md
  - openspec/specs/sdd-stack-contract.md (if it exists)
  
  Return a full audit report following your output format.
  ```

Wait for the subagent's audit report.

## Step 3 — Process Verdict

### If Verdict is `Approved`:

Display the full audit report and output:
```
✅ Spec APPROVED for change `<change-id>`.

The proposal meets all quality gates. Implementation may begin.

Next steps:
  1. Begin implementation per openspec/changes/<change-id>/tasks.md
  2. When all tasks are complete, run sdd-spec-archive to close the change.
```

### If Verdict is `Approved with Reservations`:

Display the full audit report and the list of reservations. Then output:
```
⚠️ Spec has RESERVATIONS for change `<change-id>`.

The following non-critical issues were identified:
  [list from audit report's Required Actions section]

Do you wish to proceed with implementation despite these reservations? (yes / no)
```

**Do NOT allow implementation to begin until the user explicitly confirms with "yes".**
If the user says "no", instruct them to address the reservations and re-run this skill.

### If Verdict is `Rejected`:

Display the full audit report and output:
```
❌ Spec REJECTED for change `<change-id>`.

The following REQUIRED issues must be resolved before implementation can begin:
  [list from audit report's Required Actions section]

DO NOT begin implementation. Address all required issues in proposal.md and tasks.md,
then re-run sdd-spec-validate.
```

**HARD STOP: Do NOT proceed to any implementation step. Do NOT invoke any write tools.**

## Notes
- The `sdd-spec-auditor` subagent operates in read-only, sandboxed mode.
- This skill does NOT modify any file. It only reads and reports.
- Re-running this skill after addressing issues is encouraged and costs only one subagent invocation.
