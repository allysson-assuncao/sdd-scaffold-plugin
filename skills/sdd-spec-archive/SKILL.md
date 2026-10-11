---
name: sdd-spec-archive
description: >-
  Use this skill to validate, consolidate, and archive a completed SDD change. Reads
  tasks.md to verify all tasks are done, consolidates specifications into openspec/specs/,
  then moves the change to openspec/archive/. Activate when the user asks to 'archive a spec',
  'close a change', 'merge and archive <change-id>', or 'mark this change as done'.
---

# sdd-spec-archive — Validate, Consolidate & Archive a Change

## Purpose
Close out a completed change by verifying its task checklist, consolidating its specifications into canonical living specs, and archiving the change folder with a timestamp.

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

## Step 3 — Consolidate Living Specifications

Read all files inside `openspec/changes/<change-id>/specs/`.

If `openspec/changes/<change-id>/specs/` is empty or has no spec files, proceed directly to Step 4.

For each file in `openspec/changes/<change-id>/specs/`:

### Case A: New Subsystem Specification (file does NOT end with `-delta.md`)
1. Destination path: `openspec/specs/<filename>` (must NOT contain `-delta`).
2. Verify that the file conforms to the canonical living spec standard (`spec-template.md`).
3. If `openspec/specs/<filename>` already exists:
   - Warn the user: "Canonical specification `openspec/specs/<filename>` already exists. Confirm overwrite/replacement? (yes/no)". Only proceed after explicit user confirmation.
4. Write the file to `openspec/specs/<filename>`.

### Case B: Delta Specification (file ends with `-delta.md`)
Delta specifications describe incremental modifications to existing canonical specifications. Under NO circumstance may a file ending in `-delta.md` be written or copied directly into `openspec/specs/`.

1. Identify the target canonical specification:
   - Check the frontmatter or header of the delta spec for target identifier (e.g., `Target Canonical Spec: <target-spec>.md`). If not specified, map from `<name>-delta.md` to `openspec/specs/<name>.md`.
2. Check if the target canonical specification `openspec/specs/<target-spec>.md` exists:
   - If it does NOT exist: convert the delta spec into a new canonical living spec conforming to `spec-template.md` and write it as `openspec/specs/<target-spec>.md` (without `-delta`).
   - If it exists:
     a. Read both `openspec/specs/<target-spec>.md` and the delta file `openspec/changes/<change-id>/specs/<filename>-delta.md`.
     b. Semantically merge the changes:
        - Integrate updated requirements (RF/RNF), domain entities, contracts, or sections.
        - Strip change-scoped phrasing (e.g., "In this phase we added..."). The canonical document must read as the living present-tense source of truth.
        - Increment the version in the frontmatter (`version: X.Y.Z`).
        - Append a revision entry to Revision History noting change ID `<change-id>`.
     c. Write the updated, consolidated content to `openspec/specs/<target-spec>.md`.

### Safety Verification Guard (MANDATORY)
Before proceeding to Step 4, scan `openspec/specs/`:
- Confirm that NO file ending in `-delta.md` exists in `openspec/specs/`.
- If any `*-delta.md` file is found in `openspec/specs/`, STOP immediately, remove it, and alert the user.

## Step 4 — Archive the Change Directory

Determine the archive timestamp using the current UTC date and time in format `YYYYMMDDTHHMMSSZ` (e.g., `20260923T164512Z`).

Construct the archive path: `openspec/archive/<timestamp>-<change-id>/`

Move the entire directory `openspec/changes/<change-id>/` to `openspec/archive/<timestamp>-<change-id>/`.

This includes `proposal.md`, `tasks.md`, and the `specs/` subdirectory (preserving the original delta files for immutable historical auditing).

## Step 5 — Confirm

Output a confirmation summary:

```
✅ Change `<change-id>` archived successfully.

Consolidated living specs (N files):
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
- Canonical specs in `openspec/specs/` must never contain `-delta.md` files.
- Do NOT modify `openspec/specs/` files that were NOT part of this change's specs.
