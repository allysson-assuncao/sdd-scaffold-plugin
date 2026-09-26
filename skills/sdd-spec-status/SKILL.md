---
name: sdd-spec-status
description: >-
  Use this skill to get a real-time dashboard of all active change proposals
  in openspec/changes/. Scans each change directory, parses task completion
  from tasks.md, and renders a visual progress table. Recommends immediate
  next actions for each change. Activate when the user asks 'what changes are
  active', 'show spec status', 'what is in progress', 'list open changes', or
  'show openspec dashboard'.
---

# sdd-spec-status — Active Changes Dashboard

## Purpose
Provide a fast, at-a-glance overview of all change proposals currently in `openspec/changes/`, their task completion progress, and recommended next actions.

## Prerequisites
- `openspec/changes/` must exist. If it does not, instruct the user to run `sdd-init` first and STOP.

## Step 1 — Scan Change Directories

List all subdirectories inside `openspec/changes/` (excluding `_example` unless it is the only one).

For each subdirectory `<change-id>`:
1. Check if `proposal.md` exists. If not, mark as `⚠️ Missing proposal.md`.
2. Check if `tasks.md` exists. If not, mark as `⚠️ Missing tasks.md`.
3. If both exist, read `tasks.md` and count:
   - Total tasks: all lines matching `- [x]` or `- [ ]`
   - Completed tasks: all lines matching `- [x]`
   - Compute: `progress = (completed / total) * 100` (round to nearest integer)
4. Read the first line of `proposal.md` after `# Proposal:` to get the change title.
5. Read the `> **Status:**` line from `proposal.md` to get the current status.

## Step 2 — Render Dashboard

Output the following dashboard (substituting real values):

```
📊 SDD Spec Status Dashboard
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Active Changes in openspec/changes/
───────────────────────────────────────────────────────
```

Then render a table:

| Change ID | Title | Status | Progress | Next Action |
|-----------|-------|--------|----------|-------------|
| `<id>` | <title> | <status> | X/Y (Z%) | <action> |

**Next Action logic:**
- Progress 0% and status `draft`: `📝 Fill in proposal.md`
- Progress 0% and status `under-review`: `🔍 Run sdd-spec-validate`
- Progress 0% and status `approved`: `🚀 Begin implementation`
- Progress 1-99%: `⚙️ Continue implementation (N tasks remaining)`
- Progress 100%: `📦 Run sdd-spec-archive to close this change`
- Missing files: `⚠️ Repair: create missing proposal.md or tasks.md`

After the table, output:

```
───────────────────────────────────────────────────────
Total active changes: N
Archive-ready (100%): M

Available skills:
  sdd-spec-create    → Open a new change proposal
  sdd-spec-validate  → Audit a proposal before implementation
  sdd-spec-archive   → Close and archive a completed change
```

## Step 3 — Confirm

If no changes are found (or only `_example` exists):
```
📭 No active changes found in openspec/changes/.

Run sdd-spec-create to open your first change proposal.
```

## Notes
- This skill is read-only. It does NOT modify any files.
- The `_example` directory is shown only if it is the sole directory present (indicating the project is newly initialized).
- Archived changes (in `openspec/archive/`) are NOT shown in this dashboard.
