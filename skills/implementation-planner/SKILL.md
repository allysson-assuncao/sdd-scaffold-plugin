---
name: implementation-planner
description: >-
  Use this skill to conduct the PLANNING phase of the SDD lifecycle. It takes
  an approved spec.md as input and produces a detailed implementation_plan.md
  with layered file mappings ([NEW]/[MODIFY]/[DELETE]), data model definitions,
  API contracts, and an atomic tasks.md checklist. Activate after the user has
  approved a specification (Gate 1 passed) or when the spec.md has status: approved.
---

# Skill: `implementation-planner` — Planning Phase

This skill drives the PLANNING phase of the SDD lifecycle, transforming an approved `spec.md` into a precise technical blueprint and atomic task checklist.

---

## When to Activate

Activate this skill when:
- The user has an approved `spec.md` (with `status: approved` in front-matter).
- The user says "plan this", "create the implementation plan", "break this down".
- Gate 1 has been passed and the user triggers the next phase.

---

## Prerequisite Check

**Verify the spec is approved before proceeding:**

1. Read the `spec.md` for the target feature.
2. Check YAML front-matter: `status` must be `approved`.
3. If `status` is `draft` or `in-review`, stop and inform the user:
   > _"The spec `[id]` has not yet been approved. Please complete Gate 1 with the `spec-architect` skill before planning."_

---

## Procedure

### Step 1: Analyze the Approved Spec

Read the full `spec.md`. Extract:
- All acceptance criteria scenarios (these define what must be tested).
- The data model and API contract sections (these define the interfaces).
- Non-functional requirements (these constrain implementation choices).
- Out-of-scope items (these define what NOT to build).

### Step 2: Define Data Models & Interfaces First

Before mapping files, define all data interfaces, schemas, and contracts. This is the **binding contract** between layers.

Write these definitions directly in the `implementation_plan.md` under "Data Model & Interfaces" **before** listing any file paths.

Principle: _"Define the shape of data before defining the code that processes it."_

### Step 3: Generate the File Mapping

Map every required file using `[NEW]`, `[MODIFY]`, or `[DELETE]` markers. Group files by architectural layer from innermost to outermost:

1. **Domain / Core** — pure business logic, entities, value objects (no framework dependencies)
2. **Application / Use Cases** — orchestrates domain objects, contains use case classes
3. **Infrastructure / Persistence** — database repos, external API clients, adapters
4. **API / Interface** — HTTP controllers, event handlers, CLI commands
5. **Tests** — mirror source structure in `tests/` or `__tests__/`

For each file entry, include a one-sentence description of its purpose.

Reference `resources/file-mapping-guide.md` for naming conventions and layer definitions.

### Step 4: Generate `tasks.md`

Using the `tasks.md.tmpl` template, create an atomic task checklist. Rules for tasks:

- Each task must be **completable in one focused coding session** (30–90 minutes).
- Tasks must be **sequentially ordered** — later tasks can depend on earlier ones.
- Every acceptance criterion scenario from the spec must have a corresponding test task.
- The TDD sequence must be preserved: **write failing test → implement → refactor**.

### Step 5: Trigger Gate 2

Present both `implementation_plan.md` and `tasks.md` to the user per `rules/01-approval-gates.md`:

> _"The implementation plan and task list are ready. Please review them above. Reply **APPROVED** to begin TDD implementation."_

### Step 6: On Approval

- Update `status: approved` and `updated_at` in `implementation_plan.md`.
- Update `status: approved` and `updated_at` in `tasks.md`.
- Confirm to the user: _"Plan approved. Activate `tdd-enforcer` to begin implementation."_

---

## Reference

For file naming conventions and layer definitions, read `resources/file-mapping-guide.md`.

