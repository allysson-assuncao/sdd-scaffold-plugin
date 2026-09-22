---
name: spec-architect
description: >-
  Use this skill to conduct the SPECIFICATION phase of the SDD lifecycle.
  It guides the agent to elicit requirements from the user, structure them
  as Gherkin (Given-When-Then) acceptance criteria, populate the YAML
  front-matter schema, and produce a complete spec.md artifact ready for
  Gate 1 approval. Activate when the user wants to write a spec, define
  a feature, start a new requirement, or when prompted after sdd-init.
---

# Skill: `spec-architect` — Specification Phase

This skill drives the SPECIFICATION phase of the SDD lifecycle, transforming vague feature requests into precise, testable, structured `spec.md` artifacts.

---

## When to Activate

Activate this skill when the user:
- Wants to define a new feature, fix, or refactor.
- Says "let's spec this", "write a spec for X", "define the requirements for Y".
- Has completed `sdd-init` and is ready to specify their first feature.
- Is at the start of a `sdd-cycle-orchestrator` run.

---

## Prerequisite Check

Before starting, perform the **Agentic RAG pre-planning query** (per `rules/03-agentic-rag.md`):

1. Scan the project's specs directory for existing `*.md` files.
2. Read their YAML front-matter (`id`, `feature`, `tags`, `status`).
3. If a related spec exists: surface it to the user and ask whether to extend, replace, or create a separate artifact.

---

## Procedure

### Step 1: Requirement Elicitation

Conduct a brief structured interview with the user. Ask:

1. **Feature name** — What are we building? (Used for `id` and `feature` fields.)
2. **User story** — _"As a [role], I want to [action], so that [benefit]."_
3. **Core happy path** — Walk me through the main success scenario step by step.
4. **Error cases** — What can go wrong? What inputs are invalid?
5. **Edge cases** — What are the boundary conditions or unusual-but-valid scenarios?
6. **Non-functional requirements** — Any performance targets, security constraints, or compliance requirements?
7. **Out of scope** — What explicitly does NOT belong in this feature?
8. **Blocking questions** — Are there any unknowns that would change the design?

### Step 2: Draft the `spec.md`

Use the `spec.md.tmpl` template (from `skills/sdd-init/resources/templates/`) as the structural base.

- Populate all YAML front-matter fields. Set `status: draft` initially.
- Write all acceptance criteria in **Given-When-Then format** (reference `resources/gherkin-guide.md` for quality standards).
- Every scenario must be **independently testable**.
- Every "should" or "must" must have a quantifiable assertion in the "Then" clause.

### Step 3: Invoke `spec-reviewer` Subagent

Before presenting to the user, delegate a completeness check to the `spec-reviewer` subagent:

```
Delegate to: spec-reviewer
Input: [path to the draft spec.md]
Expected output: { "status": "pass|fail", "issues": [...] }
```

If `status: fail`, fix all reported issues and repeat Step 3.

### Step 4: Present and Trigger Gate 1

Once `spec-reviewer` returns `status: pass`, present the spec to the user and trigger **Gate 1** per `rules/01-approval-gates.md`:

> _"The specification is ready and has passed automated completeness review. Please review it above. When satisfied, reply **APPROVED** to proceed to planning."_

### Step 5: On Approval

- Update `status: approved` and `updated_at` in the spec's YAML front-matter.
- Save the file.
- Confirm to the user: _"Specification approved. You can now activate `implementation-planner` to generate the technical plan."_

---

## Reference

For Gherkin writing standards, read `resources/gherkin-guide.md`.

