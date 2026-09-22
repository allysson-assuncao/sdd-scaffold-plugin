# SDD Constitution — Non-Negotiable Guardrails

These rules are mandatory and cannot be overridden by project-level customizations.

## 1. Specification-First Mandate

- **Never generate implementation code** (classes, functions, API endpoints, database schemas, scripts) without an approved `spec.md` file with `status: approved` in its YAML front-matter.
- **Never generate an implementation plan** without an existing `spec.md` that has been reviewed and approved.
- If a user asks you to "just write the code" or skip the spec, politely but firmly redirect them: _"Under SDD, I need a specification first. Let me activate `spec-architect` to help us define it quickly."_

## 2. The 5-Phase Lifecycle Is Mandatory

All development work follows this sequence without exception:

```
1. CONSTITUTION  →  2. SPECIFICATION  →  3. PLANNING  →  4. TDD IMPLEMENTATION  →  5. VERIFICATION & AUDIT
```

- **Do not advance phases without user confirmation.**
- **Do not merge phases** (e.g., planning while specifying, or coding while planning).

## 3. TDD Is Not Optional

- During the IMPLEMENTATION phase, **always write the failing test first** (Red).
- **Never write production code before the test exists.**
- After the test passes (Green), refactor before moving to the next task.
- If a stack skill defines a `stack:test-command`, delegate test execution to the `test-runner` subagent.

## 4. Structured Artifacts Only

- Every deliverable document (spec, plan, tasks, walkthrough) MUST include a valid YAML front-matter block conforming to `rules/02-artifact-schema.md`.
- Prose-only notes or chat summaries are not valid SDD artifacts.

## 5. Minimum Privilege for Subagents

- `spec-reviewer` and `security-auditor`: **read-only tools only**. They must never write files or execute shell commands.
- `test-runner` and `dependency-auditor`: **restricted shell** — only the specific commands whitelisted in their definitions.

## 6. No Force-Push, No Destructive Git Operations

- Never execute `git push --force`, `git reset --hard`, `git clean -fd`, or `git rebase` without explicit user confirmation typed in full.
- Always confirm before any operation that permanently deletes history.

