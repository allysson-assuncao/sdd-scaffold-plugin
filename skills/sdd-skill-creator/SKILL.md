---
name: sdd-skill-creator
description: >-
  Use this skill to guide the creation of new Antigravity 2.0 Skills or Rules
  within a workspace or global configuration. Scaffolds the skill directory,
  populates SKILL.md with valid frontmatter, and reminds the user of best
  practices. Activate when the user wants to 'create a new skill', 'add a rule',
  'write a custom skill', 'scaffold a new agent skill', or 'make a workflow skill'.
---

# sdd-skill-creator — Create a New Skill or Rule

## Purpose
Guide the user through creating a well-formed Antigravity 2.0 skill or rule that follows official conventions, including valid YAML frontmatter, progressive disclosure structure, and correct placement.

## Step 1 — Determine What to Create

Ask the user: "What would you like to create?"
- **Option A: Skill** — A multi-step procedural guide stored in `skills/<name>/SKILL.md`.
- **Option B: Rule (AGENTS.md)** — An always-on directive stored as `rules/AGENTS.md` or directly as `AGENTS.md` in a directory.
- **Option C: Subagent** — A specialized read-only or task-scoped subagent stored as `agents/<name>.md`.

If the user chooses **Option B (Rule)**, skip to the Rule Creation section below.
If the user chooses **Option C (Subagent)**, skip to the Subagent Creation section below.

## Step 2 — Gather Skill Metadata (Skills only)

Ask the user for the following, one question at a time:

1. **Skill name**: Must be kebab-case (e.g., `deploy-to-staging`, `run-e2e-tests`). Must start with a letter.
2. **Short description**: 1-3 sentences in third person. Explain what the skill does and when it should be activated. This text becomes the `description` frontmatter field — it is what the main agent reads to decide whether to activate the skill.
3. **Target location**: Where should the skill live?
   - `workspace` — inside the current project's `.agents/skills/<skill-name>/` (shared via VCS).
   - `global` — inside `~/.gemini/config/skills/<skill-name>/` (machine-local, all projects).

## Step 3 — Resolve Target Path

Based on the chosen location:
- **workspace**: `<workspace-root>/.agents/skills/<skill-name>/`
- **global**: `~/.gemini/config/skills/<skill-name>/` (expand `~` to the actual home directory)

Check that this directory does NOT already exist. If it does, STOP: "A skill named `<skill-name>` already exists at `<path>`. Choose a different name or edit the existing skill."

## Step 4 — Scaffold the Skill

Create the directory: `<target-path>/`

Create `<target-path>/SKILL.md` by reading `resources/skill-template.md` and substituting:
- `{{SKILL_NAME}}` → the skill name provided by the user.
- `{{SKILL_DESCRIPTION}}` → the description provided by the user (preserve line breaks in the YAML block scalar).

Ask the user: "Does this skill need resource files (templates, reference docs, scripts)?"
- If **yes**: Create `<target-path>/resources/` directory and inform the user they can add files there.
- If **no**: Skip.

## Step 5 — Remind User of Best Practices

Output the following reminder:

```
📋 Skill Best Practices (Antigravity 2.0)

1. Keep SKILL.md under 500 lines / ~5,000 tokens.
   Move heavy reference tables, schemas, or examples to resources/.

2. The `description` frontmatter is critical — the main agent uses it to
   decide whether to activate your skill. Make it specific and trigger-phrase-rich.

3. Use relative links to reference resources: [template](./resources/template.md)

4. Include a Validation section in your SKILL.md so the agent can verify
   each step succeeded before proceeding.

5. Never duplicate general coding knowledge. Focus only on your unique workflow.
```

## Step 6 — Confirm

```
✅ Skill `<skill-name>` created at:
  <target-path>/SKILL.md

Open the file and fill in the step-by-step instructions.
```

---

## Rule Creation (Option B)

If the user chose to create a **Rule**:

1. Ask: "Where should the rule apply?"
   - `workspace-global`: `<workspace-root>/.agents/rules/AGENTS.md` — applies to all files in the workspace.
   - `directory`: a specific directory path — creates `AGENTS.md` directly inside that directory.
   - `global`: `~/.gemini/config/rules/AGENTS.md` — applies to all workspaces on this machine.

2. Check if `AGENTS.md` already exists at the target path.
   - If yes: warn the user and ask whether to append or overwrite.
   - If no: create a new file.

3. Rules do NOT use YAML frontmatter. Write plain Markdown directly.

4. Remind the user: "Rules are always-on once placed. Keep them concise (ideally under 50 lines). Verbose rules consume the global 20,000-token rules budget."

5. Confirm: "✅ Rule file created/updated at `<path>`."

---

## Subagent Creation (Option C)

If the user chose to create a **Subagent**:

1. Ask the user for the following, one question at a time:
   - **Subagent name**: Must be kebab-case (e.g., `code-reviewer`, `test-runner`). Must start with a letter.
   - **Short description**: 1-3 sentences in third person. Describe the subagent's role and when the parent agent should invoke it.
   - **Tool set**: Which tools should this subagent use? Select from: `view_file`, `grep_search`, `find_by_name`, `run_command`, `write_to_file`, `replace_file_content`. For a read-only subagent, select only `view_file`, `grep_search`, `find_by_name`.
   - **Target location**: `workspace` (`.agents/agents/<name>.md`) or `global` (`~/.gemini/config/agents/<name>.md`).

2. Resolve the target path based on location choice.

3. Check that the file does NOT already exist. If it does, STOP: "A subagent named `<name>` already exists at `<path>`. Choose a different name or edit the existing subagent."

4. Create `<target-path>/<name>.md` by reading `resources/agent-template.md` and substituting:
   - `{{AGENT_NAME}}` → the subagent name.
   - `{{AGENT_DESCRIPTION}}` → the description provided by the user.
   - `{{AGENT_TOOLS}}` → the selected tool list formatted as a YAML sequence.

5. Remind the user:
   ```
   📋 Subagent Best Practices (Antigravity 2.0)

   1. Keep subagents narrowly scoped — one responsibility per subagent.
   2. Use `model: flash` for read-only or lightweight tasks to reduce cost.
   3. Set `commandExecutionPolicy: sandbox` if the subagent must not run shell commands.
   4. Always set `subagent: true` and `mainAgent: false` in the frontmatter.
   5. Never give a subagent more tools than it needs (principle of least privilege).
   ```

6. Confirm: "✅ Subagent `<name>` created at `<path>`."

## Notes
- Do NOT register the skill in `plugins.json` or `skills.json` automatically. Inform the user that workspace skills placed in `.agents/skills/` are auto-discovered.
- Do NOT modify any existing skill files other than the one being created.
