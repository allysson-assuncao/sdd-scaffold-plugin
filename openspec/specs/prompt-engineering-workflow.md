# Delta Spec: `prompt-engineering-workflow.md`

> **Change ID:** `feat-sdd-prompt-architect`
> **File:** `skills/sdd-prompt-craft/resources/prompt-guide.md` & `skills/sdd-prompt-craft/SKILL.md`
> **Change Type:** Create

---

## 1. Specification Overview

Defines the prompt engineering workflow, template taxonomy, signal detection heuristics, and walkthrough accumulation conventions used across `sdd-prompt-craft` and `sdd-prompt-architect`.

## 2. Template Taxonomy & Detection Heuristics

| Signal | Template | Output File Pattern | Purpose |
|--------|----------|---------------------|---------|
| Ambiguous / exploratory request | Template 1 (Discovery & Alignment) | `prompt-discovery.md` | Interactive interview (`/grill-me`) & discovery stubs |
| New feature, no active change in `openspec/changes/` | Template 2 (SDD Spec Planning) | `prompt-<change-id>-spec.md` | Formal change proposal & tasks checklist |
| Approved change with active `tasks.md` | Template 3 (Phased Atomic Execution) | `prompt-<change-id>-phase-<N>.md` | Execution of single phase with local commit & walkthrough logging |
| Isolated bug / surgical fix | Template 4 (Direct Fix) | `prompt-fix-<target>.md` | Lean and targeted bug resolution |

### Conflict Resolution
If repository signals are ambiguous or conflicting (e.g. an uncommitted file exists alongside an incomplete change proposal), `sdd-prompt-architect` must formulate a clarifying question to the user in Portuguese (`pt-BR`) rather than guessing.

## 3. Cumulative Walkthrough Convention

For Template 3 prompts:
- Every phase prompt instructs the executor to update or append to `openspec/changes/<change-id>/walkthrough.md`.
- Content in `walkthrough.md` is strictly formatted in Portuguese (`pt-BR`).
- Content covers:
  1. Files touched/created during the phase.
  2. Verification commands and validation outcomes.
  3. Handoff context and prerequisites for the next phase.
- The final phase consolidates all completed phases into a final execution summary.

## 4. Acceptance Criteria (Given-When-Then)

- **Scenario 1: Ambiguous exploration trigger**
  - **Given** an exploratory or ill-defined requirement from the user,
  - **When** `sdd-prompt-craft` is invoked,
  - **Then** `prompt-discovery.md` using Template 1 is generated in the project root and a clickable link is returned in chat without launching an executor.

- **Scenario 2: Phased execution trigger**
  - **Given** an approved change proposal with `tasks.md` in `openspec/changes/<change-id>/`,
  - **When** the next phase prompt is requested,
  - **Then** `prompt-<change-id>-phase-<N>.md` using Template 3 is generated, explicitly directing accumulation in `openspec/changes/<change-id>/walkthrough.md`.

- **Scenario 3: Language directives**
  - **Given** any generated prompt file,
  - **When** inspected on disk,
  - **Then** prompt body text is in English, while all user interactions, chat responses, and walkthrough notes are in Portuguese (`pt-BR`).
