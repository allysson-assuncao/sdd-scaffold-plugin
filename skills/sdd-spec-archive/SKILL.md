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
