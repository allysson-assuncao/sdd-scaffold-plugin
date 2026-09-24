# SDD Conventions — sdd-scaffold-plugin

## Spec-First Mandate
Before performing any structural code change (adding, renaming, or deleting files, APIs, or data models), you MUST:
1. Check whether an active spec already exists in `openspec/changes/` for the intended change.
2. If none exists, activate the `sdd-spec-create` skill to create one.
3. Do NOT begin implementation until a `proposal.md` has been reviewed and approved by the user.

## Namespace Separation
- `.agents/` — Agent configuration only: rules, subagents, skills, MCP configs.
- `openspec/` — Business specifications only: proposals, tasks, specs, archive.
- Never mix agent config files into `openspec/`, and never store business specs inside `.agents/`.

## Code Scanning
- For any spec that requires mapping impacted files, methods, or routes, invoke the `sdd-code-explorer` subagent.
- Prefer `sdd-code-explorer` for targeted file-tree and symbol lookups; use the native `research` subagent for broader cross-cutting questions.

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
