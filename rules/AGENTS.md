# Agentic & SDD Conventions — agentic-dev-workflow

## Adaptive Spec-First Governance (Dual-Mode)

> [!CAUTION]
> NEVER invoke `write_to_file`, `replace_file_content`, or `run_command` (for file mutations or code generation) during any planning, proposal drafting, or review phase.

Before performing any structural code change (adding, renaming, or deleting files, APIs, or data models):
1. **Strict SDD Mode (`openspec/` exists in workspace):**
   - Check whether an active spec exists in `openspec/changes/`; if none exists, activate `sdd-spec-create`.
   - DO NOT begin implementation until `proposal.md` is explicitly approved by the user and audited via `sdd-spec-validate`.
2. **Adaptive Non-SDD Mode (`openspec/` does NOT exist):**
   - Recommend initializing SDD (`sdd-init`) or creating a spec for large/structural changes, OR using `discovery-align` / `tech-research`.
   - If the user declines SDD or requests a direct workflow, respect the opt-out and proceed with lightweight alignment reports or direct implementation without blocking.

## Hard Stop: Mandatory Subagent Delegation for Code Scanning

> [!CAUTION]
> NEVER scan the codebase yourself using `view_file`, `grep_search`, or `find_by_name` chains to map impacted files or symbols. This causes context bloat in the main session window.

- For ALL codebase impact mapping, you MUST invoke the `sdd-code-explorer` subagent via `invoke_subagent` with `TypeName: "sdd-code-explorer"`.
- For broader cross-cutting research (architecture questions, documentation surveys), use the native `research` subagent.
- Wait for the subagent report before proceeding with proposal, discovery, or task list creation.

## Namespace Separation & Canonical Invariants
- `.agents/` — Agent config only: rules, subagents, skills, MCP configs, hooks. Never store business specs here.
- `openspec/specs/` — Consolidated canonical living specs ONLY. Files ending in `-delta.md` are FORBIDDEN.
- `openspec/changes/` — Active change proposals and scoped deltas. Archived to `openspec/archive/`.

## Progressive Disclosure & Archival Gate
- Never inline full skills in chat. Read specs/tasks directly. Commit all `.agents/` and `openspec/` files to Git when using SDD.
- Archival via `sdd-spec-archive` requires ALL tasks in `tasks.md` to be `[x]` and consolidates specs into canonical living format.

## Anti-Patterns (DO NOT)
- DO NOT place business specs in `.agents/` or agent configs in `openspec/`.
- DO NOT copy or write `*-delta.md` files into `openspec/specs/` (merge them into canonical specs).
- DO NOT modify `openspec/specs/` directly — always go through `openspec/changes/`.
- DO NOT commit runtime caches or engine indexes (e.g., `.antigravity/`) to Git.
- DO NOT write or modify code in an SDD workspace (`openspec/` present) before an approved proposal exists.
- DO NOT scan the codebase in the main session; always delegate to `sdd-code-explorer`.
