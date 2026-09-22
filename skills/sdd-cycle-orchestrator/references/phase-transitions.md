# Phase Transition Rules — SDD Lifecycle Management

This reference defines the precise conditions for advancing between SDD phases, handling partial states, rollback scenarios, and mid-cycle changes.

---

## Phase Advancement Conditions

| From Phase | To Phase | Required Conditions |
|---|---|---|
| SPECIFICATION | PLANNING | `spec.md` `status: approved`; all open questions resolved; Gate 1 confirmed |
| PLANNING | IMPLEMENTATION | `implementation_plan.md` `status: approved`; `tasks.md` `status: approved`; Gate 2 confirmed |
| IMPLEMENTATION | VERIFICATION | All tasks in `tasks.md` are `[x]`; `test-runner` reports all green |
| VERIFICATION | DONE | `security-auditor` finds no CRITICAL/HIGH; `dependency-auditor` finds no CVE; `walkthrough.md` complete |

---

## Rollback Scenarios

### Scenario: Spec Revised After Gate 1 Approval

If the spec must be changed after Gate 1 approval (discovered during planning or implementation):

1. Update the `spec.md` body with the change.
2. Reset `status: draft` and update `updated_at`.
3. Re-invoke `spec-reviewer` subagent.
4. Present Gate 1 again — the user must re-approve.
5. **If `implementation_plan.md` exists:** Mark it `status: draft` and regenerate.
6. **If `tasks.md` exists:** Mark it `status: draft` and review impacted tasks.

> Impact: Gate 1 + Gate 2 must both be re-passed after a spec revision.

---

### Scenario: Plan Revised After Gate 2 Approval

If the implementation plan must be changed after Gate 2 approval (discovered during coding):

1. Update `implementation_plan.md` with the change.
2. Reset `status: draft` and update `updated_at`.
3. Present Gate 2 again — the user must re-approve.
4. **If tasks are in progress:** Review and update `tasks.md` to reflect the plan change.

> Impact: Gate 2 must be re-passed. No need to re-run Gate 1 unless the spec itself changed.

---

### Scenario: Test Regression During Implementation

If a previously-passing test breaks during the IMPLEMENTATION phase:

1. **Stop all other work immediately.**
2. Identify the commit/change that caused the regression.
3. Fix the regression before writing any new code.
4. Re-run `test-runner` — confirm all previously-passing tests are green.
5. Resume the current `[/]` task.

> Never proceed with a failing test suite. Regressions compound rapidly.

---

### Scenario: CRITICAL Security Finding During Verification

If `security-auditor` returns a `CRITICAL` or `HIGH` finding:

1. **Block the walkthrough and `done` status.**
2. Present the finding to the user with file:line reference and remediation guidance.
3. Create a new task in `tasks.md` for the security fix.
4. Fix using the TDD loop (write a security test first if applicable).
5. Re-invoke `security-auditor` — must return `pass` before proceeding.

---

### Scenario: New Requirement Discovered Mid-Cycle

If the user or developer discovers a missing requirement during implementation:

**Option A (Small change, same feature scope):**
- Update the spec with the new scenario.
- Reset spec `status: draft` → re-run Gate 1.
- Update plan and tasks accordingly → re-run Gate 2.

**Option B (Significant scope expansion):**
- Create a **new `spec.md`** for the new requirement with its own `id`.
- Link it via `depends_on` to the current feature's spec.
- Finish the current cycle, then start a new SDD cycle for the new spec.

---

## Parallel Work Policy

In a team setting, multiple features may be in different SDD phases simultaneously. Rules:

1. **Never merge plans** that affect the same files without explicit conflict review.
2. Before starting a new PLANNING phase, perform the Agentic RAG pre-query (per `rules/03-agentic-rag.md`) to check for overlapping `tags`.
3. If two approved specs target the same files, present the conflict to the team before proceeding.

---

## Partial Completion Policy

If a development session ends mid-cycle:

- Save current artifact states with correct `status` values (`in-review`, `approved`, etc.).
- Leave `tasks.md` with `[/]` on the in-progress task.
- On resumption: read `tasks.md` to find the `[/]` task and continue from there.
- Never start a new cycle while tasks in a previous cycle are incomplete (`[/]` or `[ ]`).

