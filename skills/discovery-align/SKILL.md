---
name: discovery-align
description: >-
  Use this skill when the user presents a new feature scope, refactoring
  initiative, or ambiguous requirements with pending design decisions and wants
  structured workspace investigation, initial solution proposals, and interactive
  /grill-me alignment directly in the current chat before creating specs or
  writing code. Activate when the user shares a feature scope with open
  questions, asks to 'investigate and align on an approach', 'explore how to
  implement X', or starts a new development front needing architectural alignment.
---

# discovery-align — Interactive Investigation & Architecture Alignment

## Purpose
Eliminate repetitive prompting when starting new development fronts by automatically investigating relevant workspace context via read-only subagents, proposing initial implementation approaches with trade-offs in chat, aligning all open decisions with the user in `/grill-me` mode, and handing off to `sdd-spec-create` or an on-demand decision report.

## Step 1 — Investigate Workspace Context (Mandatory Subagent Delegation)

Do NOT chain file reads or searches in the main session. Delegate codebase mapping via `invoke_subagent`:
- Invoke `sdd-code-explorer` (`TypeName: "sdd-code-explorer"`, `Role: "Discovery Impact & Context Scanner"`) with the user's scope description and workspace root path to map existing modules, data flows, routes, and symbols.
- If the scope also requires broader cross-cutting architectural or documentation discovery, invoke the native `research` subagent.
- *(If the user also has an undecided technology stack or external library choice, combine or run `tech-research` first.)*

Wait for the subagent report before proposing solutions.

## Step 2 — Present Context Summary & Initial Solution Approaches

In the chat (matching the user's language, e.g. `pt-BR`), present a concise synthesis:
1. **Relevant Workspace Context:** Key existing files, patterns, data flows, and potential side effects identified by `sdd-code-explorer`.
2. **Initial Solution Proposals (2–3 Approaches):**
   - **Approach A (Recommended):** Summary, impacted components, pros, and cons.
   - **Approach B (Alternative):** Summary, impacted components, pros, and cons.
   - *(Optional)* **Approach C:** Minimal/pragmatic or alternative architectural trade-off.
3. **Open Decisions & Ambiguities:** List the specific functional, architectural, or edge-case questions that need alignment.

## Step 3 — Interactive Alignment Interview (`/grill-me`)

Walk down the decision tree with the user using the `ask_question` tool:
- Ask **one focused question at a time**.
- Put your recommended answer first, prefixed with `(Recommended)`.
- Cover architectural approach selection, data/state organization, error/edge-case handling, and persistence/handoff preference.
- Continue until all material ambiguities are resolved and a shared understanding is reached.

## Step 4 — On-Demand Persistence & Handoff

Once all decisions are aligned:

1. **SDD Handoff (`openspec/` present and user proceeds with SDD, or user accepts initializing SDD):**
   - Proceed directly to `sdd-spec-create` using the aligned scope, chosen approach, and the `Impacted Files` / `Suggested Spec Stubs` already gathered by `sdd-code-explorer` in Step 1.
   - Do **not** generate a redundant `discovery-<topic>.md` file in the project root unless the user explicitly asks for one.

2. **Non-SDD / Direct Workflow (`openspec/` absent or user explicitly opts out of SDD):**
   - Depending on the user's preference:
     a. Generate a structured decision report `discovery-<topic>.md` in the workspace root using [discovery-report-template.md](./resources/discovery-report-template.md) (validate `<topic>` as lowercase `kebab-case` matching `^[a-z][a-z0-9-]*$`), **or**
     b. Keep the aligned decision summary in chat and proceed directly to implementation.

## Rules
- Never modify project source files during Step 1, Step 2, or Step 3 (`/grill-me` alignment).
- Do NOT create a separate code-scanning subagent; always reuse `sdd-code-explorer` and `research`.
- Resolve `./resources/discovery-report-template.md` relative to this `SKILL.md` directory, never relative to the target workspace root.
