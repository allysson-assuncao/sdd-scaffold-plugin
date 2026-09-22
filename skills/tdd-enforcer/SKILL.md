---
name: tdd-enforcer
description: >-
  Use this skill to drive the TDD IMPLEMENTATION phase of the SDD lifecycle.
  It enforces strict Red-Green-Refactor cycles: write a failing test first,
  implement only the minimum code to pass it, then refactor. It reads tasks.md
  to track progress and delegates test execution to the test-runner subagent.
  Activate after the user has approved the implementation plan (Gate 2 passed)
  or when the implementation_plan.md and tasks.md have status: approved.
---

# Skill: `tdd-enforcer` — TDD Implementation Phase

This skill enforces the **Red-Green-Refactor** discipline during the IMPLEMENTATION phase. It is a loop that runs until all tasks in `tasks.md` are marked `[x]`.

---

## When to Activate

Activate this skill when:
- Gate 2 has been passed (user approved the implementation plan).
- The `implementation_plan.md` has `status: approved`.
- The user says "start coding", "implement this", "begin TDD", or "let's build".

---

## Prerequisite Check

1. Read `implementation_plan.md` — verify `status: approved`.
2. Read `tasks.md` — verify `status: approved`.
3. If either is not `approved`, stop and redirect to the appropriate gate.

---

## The TDD Loop

Repeat this cycle for each uncompleted task (`[ ]`) in `tasks.md`:

### Step 1: Read the Next Task

Find the first `[ ]` task in the current phase. Mark it `[/]` (in-progress) and `updated_at` in `tasks.md`.

### Step 2: RED — Write the Failing Test

Write the test file first. The test must:
- Reference the class, function, or endpoint defined in the `implementation_plan.md`.
- Assert the exact behavior described in the corresponding spec acceptance criterion.
- **NOT import or use any production code that doesn't exist yet** — the import itself can be a placeholder if needed.

Do NOT write any production code in this step.

### Step 3: Verify the Test Fails

Delegate test execution to the `test-runner` subagent:

```
Delegate to: test-runner
Input: test command for this project's stack
Expected: the new test must appear in the failure list
```

If the test PASSES without implementation code, this indicates the test is not testing the right behavior. Revise the test until it fails for the right reason.

### Step 4: GREEN — Implement the Minimum Code

Write the minimum production code required to make the failing test pass.

**Minimum code rules:**
- Return hardcoded values if that makes the test pass — refactoring comes next.
- Implement only what the test exercises — no speculative functionality.
- No optimization, no edge case handling not covered by the current test.

Run `test-runner` again — confirm the target test now passes and no previously-passing tests have regressed (no regressions allowed).

### Step 5: REFACTOR — Clean Up

Improve the code while keeping all tests green:
- Eliminate duplication.
- Apply naming conventions from the project.
- Extract reusable components.
- Add inline documentation.

Run `test-runner` after each refactor step — all tests must remain green.

### Step 6: Mark Complete

- Mark the task `[x]` in `tasks.md`.
- Update `updated_at` in `tasks.md`.
- Report progress: _"Task `[task description]` complete. [N] remaining."_

### Step 7: Loop or Advance

- If more `[ ]` tasks remain → return to Step 1.
- If all tasks are `[x]` → advance to VERIFICATION phase:
  - Invoke `security-auditor` subagent.
  - Invoke `dependency-auditor` subagent.
  - Produce `walkthrough.md`.
  - Update `status: done` in `tasks.md`, `implementation_plan.md`, and `spec.md`.

---

## Key Rules

1. **Never write production code before its test.** This is the single most important rule.
2. **Never skip the test-runner verification** between Red and Green phases.
3. **Never merge tasks** — complete one task fully before starting the next.
4. **Always update `tasks.md`** after each task completion.
5. **Regressions are blockers** — if a previously-passing test breaks, fix it before moving on.

---

## Reference

For Red-Green-Refactor patterns and common TDD mistakes, read `references/tdd-cycle.md`.

