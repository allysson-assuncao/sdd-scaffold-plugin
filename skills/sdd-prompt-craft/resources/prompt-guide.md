# Antigravity Agent Prompt Guide & Templates

Guidelines and modular templates for generating high-precision, token-efficient prompts for Google Antigravity autonomous agents.

---

## 1. Core Principles

- **Declarative & Goal-Oriented:** Direct the agent on the "what", "why", and constraints. Do not micromanage classes, methods, or file lines—let the agent inspect dynamic codebase state.
- **Lean Domain Framing:** Replace lengthy persona descriptions with concise domain tags: `Focus: [Backend / Spring Boot]` or `Domain: [UI / Tailwind]`.
- **Native Discovery (Zero-Waste):**
  - **Rules:** Never command agents to read `AGENTS.md` or `.agents/rules/`. The engine automatically injects rules into `<user_rules>`.
  - **Skills:** Never command manual reading of `SKILL.md`. Simply reference the skill name (e.g., `sdd-spec-create`); the engine loads skill definitions automatically.
  - **Subagents:** Delegate broad repository scans, dependency analysis, or route mapping to subagents (`sdd-code-explorer`, `research`) to keep the primary context window clean.
- **Language Rules:**
  - **Prompts:** Always written in **English**.
  - **User Interactions & Artifact Reviews:** Strictly in **Portuguese (pt-BR)** (e.g., `/grill-me` questions, user summaries, walkthroughs).
  - **Code, Commits & Tests:** Parameterized per project convention (English or pt-BR as defined by the repository context).
- **Delivery Format:** Deliver prompts in raw markdown code blocks (````text ... ````) without UI rendering, enabling direct one-click copying to the IDE.

---

## 2. Modular Prompt Templates

### Template 1: Discovery & Architecture Alignment (`/grill-me`)
*Use for ambiguous requirements, design trade-offs, or initial impact discovery before planning. The prompt provides initial seed questions based on user context, but the executing agent retains full autonomy to raise any additional questions discovered during analysis.*

````text
Focus: [Domain/Stack]
Task: [Concise task description]

## Context & Objectives
[High-level problem summary and known constraints.]

## Phase 1: Targeted Discovery
Inspect relevant code without guessing state. Delegate broad mapping to `sdd-code-explorer`:
- Inspect [target entry points / core modules].
- Map data flows and potential side effects.

## Phase 2: Interactive Interview (`/grill-me`)
Before proposing solutions, planning, or modifying code, enter `/grill-me` mode:
- Conduct interview strictly in Portuguese (pt-BR).
- Ask one focused question at a time covering trade-offs and edge cases.
- Address the seed questions suggested below, but exercise full autonomy to investigate and ask about any additional ambiguities, edge cases, or architectural constraints uncovered during your analysis:
  * [Suggested Topic/Question 1 based on user context]
  * [Suggested Topic/Question 2 based on user context]
  * [Autonomously raise any other critical gaps or uncertainties discovered]

Stop execution and await user responses.
````

---

### Template 2: SDD Spec & Implementation Planning (`openspec`)
*Use after architectural alignment to create a formal SDD proposal and task breakdown.*

````text
Focus: [Domain/Stack]
Task: Create SDD Change Proposal for [Feature / Refactor Name]

## Objective
Structure a formal change proposal following the project's Spec-Driven Development conventions.

## Instructions
1. Activate skill `sdd-spec-create` under `openspec/changes/`.
2. Target change name: [kebab-case-change-name]
3. Required proposal elements:
   - Problem & Scope
   - Impacted Areas (invoke `sdd-code-explorer` if needed)
   - Delta Specs for `openspec/specs/`
   - Atomic Task Breakdown (`tasks.md`)

Do NOT modify production source code. Present proposal artifact for user review.
````

---

### Template 3: Phased Atomic Execution (For Existing Plans)
*Use to execute single atomic phases from an approved plan with verification and local commits.*

````text
Focus: [Domain/Stack]
Task: Execute Phase [N]: [Phase Title]

## Execution Context
- Active Plan: [Path to tasks.md or spec reference]
- Scope: Execute Phase [N] only. Do not proceed to subsequent phases.

## Implementation Steps
1. [Atomic action 1]
2. [Atomic action 2]
3. [Atomic action 3]

## Quality Gates & Verification
- Run local validation: `[command: npm test / mvn test / lint]`
- Commit locally: `[commit message format, e.g., feat(scope): message]`

## Phase Handoff & Cumulative Walkthrough
Update or create a shared walkthrough artifact (`openspec/changes/<change-id>/walkthrough.md` in pt-BR) recording execution progress:
1. List of files created/modified in this phase.
2. Verification and test results.
3. Handoff context prepared for Phase [N+1].
*(If this is the final phase, complete the walkthrough with a full consolidated summary of all changes and actionable next steps, such as manual UI/CLI validations or user review checklists).*
````

---

### Template 4: Direct Fix / Targeted Adjustment (Lean & Fast)
*Use for isolated bug fixes or small surgical adjustments.*

````text
Focus: [Domain/Stack]
Task: [Direct fix summary]

## Target & Scope
- Problem: [Brief issue description]
- Location: [Target file(s) or component]

## Constraints
- Keep changes minimal and surgical without unneeded dependencies.
- Verify resolution locally.
- Final summary in Portuguese (pt-BR).
````

---

## 3. Sequential Prompt Execution & Cumulative Walkthrough

When executing complex or multi-phase implementation plans:
1. **Atomic Fanning:** Break down the plan into atomic phases and emit separate **Template 3** blocks for each phase.
2. **Intermediate Gates:** Enforce local test validation and atomic commits before advancing to the next phase.
3. **Shared Cumulative Walkthrough:** Maintain a single shared walkthrough artifact across phases. Each phase appends its own progress summary. Upon completing the final phase, the walkthrough must consolidate the full change summary and provide clear next steps (e.g., manual smoke tests, edge-case verification, or user review checklists).

---

## 4. Template Selection & File Naming (used by `sdd-prompt-architect`)

| Signal | Template | Output file |
|--------|----------|-------------|
| Ambiguous / exploratory request | 1 | `prompt-discovery.md` |
| New feature, no active change in `openspec/changes/` | 2 | `prompt-<change-id>-spec.md` |
| Approved change with `tasks.md` | 3 (one file per phase) | `prompt-<change-id>-phase-<N>.md` |
| Isolated bug / surgical fix | 4 | `prompt-fix-<target>.md` |

If signals conflict, ask the user (pt-BR) which template to use.
Write each prompt as a standalone file in the project root; never inline it only in chat.

