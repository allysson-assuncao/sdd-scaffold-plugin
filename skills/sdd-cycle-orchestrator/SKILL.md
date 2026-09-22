---
name: sdd-cycle-orchestrator
description: >-
  Use this skill to orchestrate the complete 5-phase SDD lifecycle for a feature
  from start to finish: Constitution → Specification → Planning → TDD Implementation
  → Verification & Audit. It chains spec-architect, implementation-planner, and
  tdd-enforcer in sequence, enforces both approval gates, delegates to all four
  subagents at the appropriate phases, and produces a final walkthrough.md.
  Activate when the user wants to build a feature end-to-end following SDD, or
  when starting a new development cycle from scratch.
---

# Skill: `sdd-cycle-orchestrator` — Full SDD Lifecycle

This skill is the **master orchestrator** for the complete SDD lifecycle. It chains all sub-skills and subagents in the correct order, enforcing all gates and producing all required artifacts.

---

## When to Activate

Activate this skill when the user:
- Wants to build a feature completely from scratch using SDD.
- Says "let's do a full SDD cycle", "build this end-to-end", or "orchestrate the whole thing".
- Is starting a new sprint or development session.

---

## The 5-Phase Orchestration

```
Phase 1: CONSTITUTION (already active via plugin rules)
    ↓
Phase 2: SPECIFICATION  →  [Gate 1]  →  approved
    ↓
Phase 3: PLANNING       →  [Gate 2]  →  approved
    ↓
Phase 4: TDD IMPLEMENTATION
    ↓
Phase 5: VERIFICATION & AUDIT
    ↓
  Done: walkthrough.md produced
```

---

## Orchestration Steps

### Phase 1: Constitution (Passive)

The plugin's rules (`rules/00-sdd-constitution.md` through `rules/03-agentic-rag.md`) are always-on. No active step needed. Confirm to the user that the SDD governance layer is active.

> _"SDD governance is active. All rules, approval gates, and artifact schemas are enforced. Let's begin with the specification."_

---

### Phase 2: Specification

1. **Activate `spec-architect` skill** — conduct the full elicitation and drafting procedure.
2. **Invoke `spec-reviewer` subagent** — automated completeness validation.
3. **Gate 1** — present spec, wait for `APPROVED`.
4. On approval: update `spec.md` to `status: approved`.

---

### Phase 3: Planning

1. **Activate `implementation-planner` skill** — conduct the full planning procedure.
2. **Gate 2** — present plan + tasks, wait for `APPROVED`.
3. On approval: update `implementation_plan.md` and `tasks.md` to `status: approved`.

---

### Phase 4: TDD Implementation

1. **Activate `tdd-enforcer` skill** — drive the Red-Green-Refactor loop until all tasks are `[x]`.
2. **Invoke `test-runner` subagent** at each Red→Green transition for automated test execution.
3. Report incremental progress after each completed task.

---

### Phase 5: Verification & Audit

Execute all four verification steps in parallel where possible:

1. **Invoke `security-auditor` subagent** — OWASP Top 10 + secrets scan.
   - If `CRITICAL` or `HIGH` findings → block, fix, re-audit before proceeding.
   - If only `MEDIUM`/`LOW` → document findings in walkthrough, proceed.

2. **Invoke `dependency-auditor` subagent** — CVE and outdated dependency scan.
   - If vulnerable dependencies with CVEs → fix before proceeding.

3. **Invoke `test-runner` subagent** — full suite run.
   - All tests must be green. Any failure blocks progress.

4. **Produce `walkthrough.md`** — using the `walkthrough.md.tmpl` template:
   - Summary of all changes.
   - Test evidence (paste `test-runner` output).
   - Security and dependency audit results.
   - Acceptance criteria verification table (map each Gherkin scenario to its test).

---

### Closeout

- Update all artifact statuses to `done`.
- Update `verified_by` in `spec.md` and `implementation_plan.md` with the walkthrough `id`.
- Report to user:

> _"Feature `[feature name]` complete. All phases passed, all gates cleared, all audits clean. The walkthrough.md is at `[path]`."_

---

## Phase Transition Rules

For detailed rules on when and how to advance between phases (including partial rollback scenarios), read `references/phase-transitions.md`.

