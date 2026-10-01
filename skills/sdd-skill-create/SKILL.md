---
name: sdd-skill-create
description: >-
  Use this skill to scaffold a new Antigravity 2.0 Skill within a workspace or
  global configuration. Scaffolds the skill directory with a valid SKILL.md
  (populated from template with correct YAML frontmatter) and optional
  subdirectories (resources/, scripts/, references/). Activate when the user
  wants to 'create a new skill', 'scaffold a skill', 'add a custom agent skill',
  or 'make a workflow skill'.
---

# sdd-skill-create — Scaffold a New Skill

## Purpose
Create a well-formed Antigravity 2.0 skill directory with a valid `SKILL.md` file following official conventions: YAML frontmatter, progressive disclosure structure, and correct placement.

## Step 1 — Gather Skill Metadata

Ask the user for the following (one question at a time if not already provided):

1. **Skill name**: Must be kebab-case (e.g., `deploy-to-staging`, `run-e2e-tests`). Must start with a letter.
2. **Short description**: 1–3 sentences in third person. Explain what the skill does and when it should be activated. This text becomes the `description` frontmatter field.
3. **Target location**:
   - `workspace` — inside the current project's `.agents/skills/<skill-name>/` (shared via VCS)
   - `global` — inside `~/.gemini/config/skills/<skill-name>/` (machine-local, all projects)
4. **Optional subdirectories** needed: `resources/` (templates, reference docs), `scripts/` (helper scripts), `references/` (additional docs)?

## Step 2 — Resolve and Validate Target Path

Based on the chosen location:
- **workspace**: `<workspace-root>/.agents/skills/<skill-name>/`
- **global**: `<actual-home-dir>/.gemini/config/skills/<skill-name>/`

Expand `~` to the actual home directory path.

Check that this directory does NOT already exist. If it does:
```
❌ STOP: A skill named `<skill-name>` already exists at `<path>`.
   Choose a different name or edit the existing skill directly.
```

## Step 3 — Confirm Before Creating

Display the following execution plan and wait for explicit user confirmation:

```
📋 New Skill — Execution Plan

Skill name:   <skill-name>
Location:     <full-path>

Files to create:
  <full-path>/SKILL.md

Directories to create:
  <full-path>/
  <full-path>/resources/    (if requested)
  <full-path>/scripts/      (if requested)
  <full-path>/references/   (if requested)

Confirm? (yes / no)
```

Do NOT proceed until the user confirms with "yes".

## Step 4 — Scaffold the Skill

Read `resources/skill-template.md` and substitute:
- `{{SKILL_NAME}}` → the skill name
- `{{SKILL_DESCRIPTION}}` → the description (preserve line breaks in the YAML block scalar)

Write the result to `<target-path>/SKILL.md`.

Create any optional subdirectories requested by the user.

## Step 5 — Confirm

```
✅ Skill `<skill-name>` scaffolded at: <target-path>/SKILL.md

Best practices reminder:
  1. Keep SKILL.md under 500 lines / ~5,000 tokens.
     Move heavy reference tables or schemas to resources/.
  2. The `description` frontmatter drives skill activation — make it specific and trigger-rich.
  3. Use relative links for resources: [template](./resources/template.md)
  4. Include a Validation section after each Step so the agent can verify success.
  5. Never duplicate general coding knowledge. Focus only on your unique workflow.

Next step: Open <target-path>/SKILL.md and fill in the step-by-step instructions.
```

## Notes
- Skills placed in `.agents/skills/` are auto-discovered — no registration in `plugins.json` needed.
- Do NOT modify any existing skill files.
