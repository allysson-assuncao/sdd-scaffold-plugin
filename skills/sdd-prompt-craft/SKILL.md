---
name: sdd-prompt-craft
description: >-
  Use this skill to generate a structured, token-efficient prompt file for a heavier
  execution model. Gathers the user's intent, then delegates to the lightweight
  sdd-prompt-architect subagent, which picks the right template (discovery, SDD
  planning, phased execution, direct fix) and writes prompt-*.md in the project root.
  Activate when the user wants to 'create a prompt', 'generate a prompt for the
  executor', 'prepare a prompt', 'write the next phase prompt', or 'craft a prompt'.
---

# sdd-prompt-craft — Structured Prompt Generation

## Purpose
Produce prompt files that command stronger models, using the templates in
`resources/prompt-guide.md`, without bloating the main session context.

## Step 1 — Gather intent
Ask the user (pt-BR) only what is missing: goal, target area, and whether a change in
`openspec/changes/` is involved. Do not scan the codebase yourself.

## Step 2 — Delegate
Invoke `sdd-prompt-architect` via `invoke_subagent` (`TypeName: "sdd-prompt-architect"`)
with the user's intent and the path `skills/sdd-prompt-craft/resources/prompt-guide.md`
(resolve it relative to this skill's directory).

## Step 3 — Report
Relay the subagent's result: the clickable link to the generated file and the template
chosen, in pt-BR. Then wait for user review.

## Rules
- NEVER launch an execution agent with the generated prompt. The user decides.
- Generated prompts are in English; user-facing messages in pt-BR.
- Do not paste the prompt body into chat; link the file.
