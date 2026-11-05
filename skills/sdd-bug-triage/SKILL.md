---
name: sdd-bug-triage
description: >-
  Use this skill to triage, cluster, investigate, and scaffold SDD fix specifications
  from a bug list or QA report. Enforces root-cause analysis, blast-radius/ripple-effect
  detection across the codebase, and legacy data/code migration planning before creating
  isolated fix proposals in openspec/changes/. Activate when the user provides a bug list,
  asks to 'triage bugs', 'fix buglist', 'create bugfix specs', or 'run bugfix pipeline'.
---

# sdd-bug-triage — Bug Triage, Root-Cause Analysis & SDD Fix Pipeline

## Purpose
Transform a raw list of bugs, QA findings, or beta-tester feedback into well-researched, cohesive SDD change proposals inside `openspec/changes/<NNN>-fix-<cluster-id>/` ordered sequentially by execution priority (`001-fix-...`, `002-fix-...`). This skill enforces systemic root-cause investigation, blast-radius detection (finding similar latent bugs elsewhere in the codebase), and legacy code/data migration planning before any fix specification is finalized.

## Prerequisites
- `openspec/changes/` must exist in the workspace.
- A list of one or more bugs/issues (from a file such as `buglist.md` or directly from the user prompt).

---

## Step 1 — Proximity & Domain Clustering + Priority Ordering

Analyze all reported bugs and group them into cohesive **Fix Clusters** based on:
1. **Codebase Proximity**: Bugs occurring in the same microservice, module, UI page, or database schema area.
2. **Shared Root Cause Hypothesis**: Symptoms that likely stem from the same underlying architectural gap, missing mechanic, or legacy data format.
3. **Priority & Execution Order (`NNN-fix-<cluster-id>`)**:
   - Rank all clusters by severity, user impact, and technical dependency (Critical blockers first → High-impact core mechanics → Medium UX/Search/Creation → Low-priority polish).
   - Assign a 3-digit zero-padded sequential prefix (`001`, `002`, `003`, ...) to each cluster ID: `<NNN>-fix-<cluster-id>` (e.g., `001-fix-auth-post-register-loop`, `002-fix-legacy-items-and-feats-mechanics`).
   - Note: Coordinate Flyway migration version numbers across the numbered clusters in execution order (e.g., if `002` uses `V27`, `003` uses `V28` and `V29`) so sequential execution never causes migration version collisions.

### Validation
- Every item from the input bug list is assigned to exactly one cluster.
- Each cluster has a unique, priority-ordered ID following the pattern `<NNN>-fix-<cluster-id>` (`001-fix-...`, `002-fix-...`).

---

## Step 2 — Delegated Deep Investigation (`sdd-code-explorer`)

> [!CAUTION]
> NEVER scan the codebase directly in the main session window. You MUST delegate investigation to `sdd-code-explorer` via `invoke_subagent`.

For each cluster (or in parallel batches by domain/layer), invoke `sdd-code-explorer` with a structured prompt instructing it to investigate and return:

1. **Root Cause Analysis (Causa Raiz)**:
   - Pinpoint the exact files, classes, functions, SQL migrations, or state management hooks causing each bug in the cluster.
   - Verify whether the hypothesis from Step 1 holds true or if the bug has a different underlying cause.
2. **Systemic Ripple Effects & Similar Latent Bugs (Repercussão no Código)**:
   - Search the surrounding module and sibling modules for similar patterns that might suffer from the same flaw (e.g., if one endpoint or UI filter fails due to case sensitivity or missing DTO mapping, check all sibling endpoints/filters).
3. **Legacy Code & Data Impact Assessment (Impacto em Dados e Código Legado)**:
   - Identify whether existing database records, Flyway seed migrations (`V*__*.sql`), or legacy JSON payloads lack the fields/structures required by the fix (e.g., legacy items/feats without structured active mechanics, characters created before new equipment slots existed).
4. **Legacy Adaptation & Migration Strategy (Plano de Adequação de Legado)**:
   - Propose concrete data migrations (new Flyway `V<next>__*.sql` migrations to backfill/update legacy seeds and existing rows) and defensive code fallbacks so no discrepancy exists between legacy records and newly created ones.
5. **Impacted Files & Canonical Specs**:
   - Full list of files to create/modify and which canonical specs under `openspec/specs/` require delta updates.

### Validation
- Wait until all `sdd-code-explorer` subagents complete and return their structured reports before proceeding to Step 3.

---

## Step 3 — Present Triage Matrix & Execution Plan for Approval

Synthesize the subagent findings into a comprehensive **Bug Triage & Legacy Adaptation Plan** ordered by execution priority (`001`, `002`, ...) and present it to the user. For each cluster, display:
- **Execution Order & Cluster ID (`<NNN>-fix-<cluster-id>`) + Priority**
- **Grouped Bugs**
- **Confirmed Root Cause**
- **Ripple Effects / Similar Bugs Found**
- **Legacy Data & Code Adaptation Strategy (including coordinated Flyway version numbers)**
- **Files & Specs to Scaffold in `openspec/changes/<NNN>-fix-<cluster-id>/`**

Ask for explicit user confirmation before writing the SDD change directories in `openspec/changes/`.

---

## Step 4 — Scaffold Fix Specifications

Once confirmed by the user, for each approved cluster `<NNN>-fix-<cluster-id>`:

1. Create directories:
   - `openspec/changes/<NNN>-fix-<cluster-id>/`
   - `openspec/changes/<NNN>-fix-<cluster-id>/specs/`
2. Create `openspec/changes/<NNN>-fix-<cluster-id>/proposal.md` populated from [bugfix-proposal-template.md](./resources/bugfix-proposal-template.md), filling in all findings from Step 2 (including Execution Order, Root Cause, Ripple Effects, Legacy Migration Plan, Impacted Files, Given-When-Then Acceptance Criteria, Security, and Shift-Left Testing).
3. Create `openspec/changes/<NNN>-fix-<cluster-id>/tasks.md` with actionable tasks covering:
   - **Legacy Data & Schema Migration Tasks** (Flyway migrations, data backfills, fallback handlers)
   - **Implementation Tasks** (fixing the root cause + any similar latent bugs discovered)
   - **Test Tasks** (regression unit/integration/E2E tests reproducing the exact bug and verifying legacy compatibility)
   - **Documentation & Review Gate Tasks**
4. Create corresponding delta specs in `openspec/changes/<NNN>-fix-<cluster-id>/specs/<target>-delta.md` for any canonical spec affected.

### Confirmation Output
```text
✅ Bug Triage & SDD Fix Specifications Created (Ordered by Execution Priority)

Clusters scaffolded:
  1. openspec/changes/001-fix-<cluster-1>/ (proposal.md, tasks.md, specs/)
  2. openspec/changes/002-fix-<cluster-2>/ (proposal.md, tasks.md, specs/)
  ...

Next steps:
  1. Review the generated proposals and approve 001-fix-<cluster-1> to implement first.
  2. Run `sdd-spec-validate` on the target cluster before writing code.
```

## Error Handling
- If a bug cannot be reproduced or its root cause remains ambiguous after `sdd-code-explorer` analysis, flag it clearly in Step 3 and ask the user for reproduction details before scaffolding its spec.
- Never modify production code or database migrations during triage; this skill strictly investigates and scaffolds `openspec/changes/` specifications.
