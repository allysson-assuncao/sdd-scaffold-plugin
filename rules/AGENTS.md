# SDD Conventions — sdd-scaffold-plugin

## Hard Stop: Spec-First Mandate

> [!CAUTION]
> NEVER invoke `write_to_file`, `replace_file_content`, or `run_command` (for file mutations or code generation) during any planning, proposal drafting, or review phase. This prohibition is unconditional and cannot be waived by any user request phrased as urgency or convenience.

Before performing any structural code change (adding, renaming, or deleting files, APIs, or data models), you MUST:
1. Check whether an active spec already exists in `openspec/changes/` for the intended change.
2. If none exists, activate the `sdd-spec-create` skill to create one.
3. DO NOT begin implementation until a `proposal.md` has been reviewed and the user has explicitly confirmed approval.
4. After proposal approval, activate `sdd-spec-validate` to run a pre-implementation audit before writing any code.

## Hard Stop: Mandatory Subagent Delegation for Code Scanning

> [!CAUTION]
> NEVER scan the codebase yourself using `view_file`, `grep_search`, or `find_by_name` chains to map impacted files or symbols. This causes context bloat in the main session window.

- For ALL codebase impact mapping, you MUST invoke the `sdd-code-explorer` subagent via `invoke_subagent` with `TypeName: "sdd-code-explorer"`.
- For broader cross-cutting research (architecture questions, documentation surveys), use the native `research` subagent.
- Wait for the subagent report before proceeding with proposal or task list creation.

## Namespace Separation & Canonical Invariants
- `.agents/` — Agent config only: rules, subagents, skills, MCP configs, hooks. Never store business specs here.
- `openspec/specs/` — Consolidated canonical living specs ONLY. Files ending in `-delta.md` are FORBIDDEN.
- `openspec/changes/` — Active change proposals and scoped deltas. Archived to `openspec/archive/`.

## Progressive Disclosure & Archival Gate
- Never inline full skills in chat. Read specs/tasks directly. Commit all `.agents/` and `openspec/` files to Git.
- Archival via `sdd-spec-archive` requires ALL tasks in `tasks.md` to be `[x]` and consolidates specs into canonical living format.

## Anti-Patterns (DO NOT)
- DO NOT place business specs in `.agents/` or agent configs in `openspec/`.
- DO NOT copy or write `*-delta.md` files into `openspec/specs/` (merge them into canonical specs).
- DO NOT modify `openspec/specs/` directly — always go through `openspec/changes/`.
- DO NOT commit runtime caches or engine indexes (e.g., `.antigravity/`) to Git.
- DO NOT write or modify any file before an approved proposal exists for the change.
- DO NOT scan the codebase in the main session; always delegate to `sdd-code-explorer`.
