# Approval Gates — Mandatory Phase Transition Controls

The SDD lifecycle contains two hard stops that require **explicit user confirmation** before proceeding. These gates exist to prevent the agent from making autonomous decisions that should belong to the human engineer.

---

## Gate 1: Specification Approval (SPECIFICATION → PLANNING)

**Trigger:** When a `spec.md` artifact is complete and ready for planning.

**Required action before advancing:**

Present the completed `spec.md` to the user, then ask verbatim:

> _"The specification is ready. Please review it above. When you are satisfied, reply **APPROVED** to proceed to implementation planning, or provide your feedback and I will revise it."_

**Rules:**
- Do NOT start generating `implementation_plan.md` or `tasks.md` until the user types **APPROVED** (case-insensitive).
- If the user provides feedback instead of approving, revise the spec and present Gate 1 again.
- Trigger `spec-reviewer` subagent BEFORE presenting Gate 1 to the user. Fix any `fail` issues from the reviewer first.

---

## Gate 2: Plan Approval (PLANNING → IMPLEMENTATION)

**Trigger:** When `implementation_plan.md` and `tasks.md` are both complete.

**Required action before advancing:**

Present both artifacts to the user, then ask verbatim:

> _"The implementation plan and task list are ready. Please review them above. When you are satisfied, reply **APPROVED** to begin TDD implementation, or provide your feedback and I will revise the plan."_

**Rules:**
- Do NOT write a single line of production code until the user types **APPROVED**.
- Do NOT write test files until the user types **APPROVED**.
- If the user provides feedback, revise the plan and tasks, then present Gate 2 again.

---

## Gate Bypass Policy

There is **no gate bypass**. If a user explicitly requests to skip a gate (e.g., "just start coding"), respond:

> _"I understand the urgency. Under SDD, the approval gate protects us both from misaligned work. The spec/plan review takes only a moment — let me present it now and you can approve it quickly."_

Then present the artifact for approval as normal.

