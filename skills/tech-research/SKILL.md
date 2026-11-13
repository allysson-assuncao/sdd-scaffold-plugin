---
name: tech-research
description: >-
  Use this skill when the user needs to choose a technology stack, library,
  framework, database, or architectural pattern for a new feature or refactoring
  and has not defined the specific technology yet. Profiles workspace constraints
  via tech-profiler, researches market standards and reference architectures via
  search_web, presents candidate options in chat, and aligns the decision with
  the user in /grill-me mode. Activate when the user asks 'which technology should
  I use', 'help me choose a stack or library', 'research options for refactoring',
  or describes a capability with an undecided tech stack.
---

# tech-research — Technology & Architecture Research Workflow

## Purpose
Guide the user through a systematic, evidence-based technology or architecture selection directly in the active chat—combining local workspace profiling (`tech-profiler`), live market research (`search_web`), trade-off comparison, and interactive `/grill-me` alignment.

## Step 1 — Profile Workspace Constraints (Mandatory Subagent Delegation)

Do NOT scan the codebase yourself in the main session. Invoke the `tech-profiler` subagent via `invoke_subagent`:
- `TypeName`: `"tech-profiler"`
- `Role`: `"Workspace Stack Profiler"`
- `Prompt`: Provide the workspace root path, the user's feature/refactoring goal, and the undecided technology domain.

Wait for `tech-profiler` to return its structured report (`Current Stack Identity`, `Existing Patterns in Target Area`, `Technical Constraints & Compatibility Requirements`, and `Open Gaps & Research Targets`).

*(Fallback: if `tech-profiler` is unavailable, delegate the local manifest scan to `sdd-code-explorer` or native `research`.)*

## Step 2 — External Market & Reference Architecture Research

Using the constraints and gaps identified in Step 1:
1. Run targeted `search_web` queries in the main agent for current ecosystem standards, libraries, benchmarks, and reference architectures that fit the workspace's runtime and constraints.
2. Evaluate candidate technologies across:
   - **Compatibility:** Fit with existing language/runtime, framework, and `sdd-stack-contract.md`.
   - **Maintenance & Security Posture:** Active maintenance, community adoption, license compatibility, and absence of known unpatched security issues.
   - **Developer Experience & Complexity:** Learning curve, boilerplate, testability, and migration cost.
3. Select the **2 to 4 best options** (avoid overwhelming dumps).

## Step 3 — Present Options & Align via `/grill-me`

1. In the chat (matching the user's language, e.g. `pt-BR`), present:
   - A brief summary of the project's detected stack and constraints;
   - A structured comparison table of the **2–4 candidate options** (Pros, Cons, Best For, Ecosystem Fit);
   - Your initial recommendation and rationale.
2. Enter **`/grill-me` mode** using the `ask_question` tool:
   - Ask **one focused question at a time** to resolve pending trade-offs (e.g., bundle size vs. feature richness, strict typing vs. flexibility, migration effort) and confirm the final choice.
   - Always place the recommended option first, prefixed with `(Recommended)`.

## Step 4 — On-Demand Persistence & Handoff

Once the technology/architecture decision is aligned with the user:

1. **If working in an SDD workspace (`openspec/` exists) and the user wants to follow SDD:**
   - Update `openspec/specs/sdd-stack-contract.md` (or seed it from [sdd-stack-contract.md](../sdd-init/resources/sdd-stack-contract.md) if missing) with the chosen technology and architectural constraints.
   - Ask if the user wants to proceed directly to `discovery-align` or `sdd-spec-create` to open the change proposal in `openspec/changes/`.
   - Do **not** create redundant `tech-decision-*.md` files in the project root unless explicitly requested.

2. **If working in a non-SDD workspace (or the user opts out of SDD):**
   - Ask whether the user wants to:
     a. Save a standalone decision record `tech-decision-<topic>.md` in the workspace root using [tech-decision-template.md](./resources/tech-decision-template.md) (validate `<topic>` as lowercase `kebab-case` matching `^[a-z][a-z0-9-]*$`), **or**
     b. Keep the decision summary only in chat and proceed directly to implementation or `discovery-align`.

## Rules
- Never mutate project source code during research or `/grill-me` alignment.
- Always delegate workspace manifest/code scanning to `tech-profiler` (or `sdd-code-explorer` / `research`) to avoid main-session context bloat.
- Resolve `./resources/tech-decision-template.md` relative to this `SKILL.md` directory, never relative to the target workspace root.
