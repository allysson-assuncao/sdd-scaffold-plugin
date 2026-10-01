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

## Namespace Separation
- `.agents/` — Agent configuration only: rules, subagents, skills, MCP configs, hooks.
- `openspec/` — Business specifications only: proposals, tasks, specs, archive.
- Never mix agent config files into `openspec/`, and never store business specs inside `.agents/`.

## Progressive Disclosure
- Never inline the full content of a skill into your response. Activate skills on demand.
- When referencing a spec or task file, read it; do not guess its contents.

## Version Control
- ALL files created inside `.agents/` and `openspec/` MUST be committed to Git.
- Never write runtime caches, indexes, or ephemeral outputs into these directories.

## Archival Gate
- A change may only be archived via `sdd-spec-archive` after ALL tasks in `tasks.md` are marked `[x]`.
- Incomplete tasks block archival unconditionally.

## Anti-Patterns (DO NOT)
- DO NOT place business specs (proposal.md, tasks.md) inside `.agents/`.
- DO NOT place agent configs (SKILL.md, AGENTS.md, agent definitions) inside `openspec/`.
- DO NOT inline the full body of a skill or spec file into a chat response.
- DO NOT modify `openspec/specs/` directly — always go through `openspec/changes/`.
- DO NOT commit runtime caches or engine indexes (e.g., `.antigravity/`) to Git.
- DO NOT write or modify any file before an approved proposal exists for the change.
- DO NOT scan the codebase in the main session; always delegate to `sdd-code-explorer`.
