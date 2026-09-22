# Contributing — Building Stack Plug-ins for `sdd-scaffold-plugin`

This guide explains how to build a technology-specific skill ("stack skill") that is fully compatible with the `sdd-scaffold-plugin` SDD lifecycle.

---

## Overview

The `sdd-scaffold-plugin` is **stack-agnostic by design**. It provides the SDD methodology layer (rules, approval gates, subagents). Stack skills provide the technology layer (project structure, test patterns, framework conventions).

The two layers connect via the **Stack Contract** — three declared hooks in the stack skill's SKILL.md frontmatter.

---

## Prerequisites

Before building a stack skill:

1. Read the `stack-contract` skill (`skills/stack-contract/SKILL.md`) in full.
2. Understand the three required hooks: `test_command`, `lint_command`, `setup_command`.
3. Copy the blank template: `skills/stack-contract/resources/stack-skill-template/SKILL.md.tmpl`.

---

## Step-by-Step: Creating a New Stack Skill

### Step 1: Create the Skill Directory

```bash
# Inside your skills repository or global plugins directory:
mkdir -p ~/.gemini/config/plugins/<stack-name>-stack/skills/<stack-name>-stack/
```

**Naming convention:** `<technology>-stack` or `<language>-<framework>-stack`

Examples: `spring-boot-stack`, `nextjs-stack`, `python-fastapi-stack`, `go-gin-stack`

### Step 2: Copy and Fill the Template

```bash
cp /path/to/sdd-scaffold-plugin/skills/stack-contract/resources/stack-skill-template/SKILL.md.tmpl \
   ~/.gemini/config/plugins/<stack-name>-stack/skills/<stack-name>-stack/SKILL.md
```

Fill in:
- `name:` — must match the directory name
- `description:` — third-person, states when to activate, must mention the stack name
- `sdd_stack_contract.test_command` — exact shell command, exits 0 on pass
- `sdd_stack_contract.lint_command` — exact shell command, exits 0 on clean
- `sdd_stack_contract.setup_command` — exact command to bootstrap the project

### Step 3: Add the Plugin Manifest

Create `~/.gemini/config/plugins/<stack-name>-stack/plugin.json`:

```json
{
  "name": "<stack-name>-stack",
  "version": "1.0.0",
  "description": "SDD-compatible stack skill for <Technology/Framework>."
}
```

### Step 4: Add Examples

Create `skills/<stack-name>-stack/examples/` with at minimum:
- A canonical domain entity file with unit tests.
- A use case file with mocked dependencies.
- An API endpoint file with an integration test.

These serve as the **canonical patterns** the agent references during TDD implementation.

### Step 5: Validate Against the Stack Contract Checklist

Activate the `stack-contract` skill in Antigravity and ask it to validate your new skill against the compatibility checklist.

---

## Registering the Stack Skill in a Project

In the project's `.agents/plugins.json`, declare both plugins:

```json
{
  "entries": [
    {
      "path": "~/.gemini/config/plugins/sdd-scaffold-plugin",
      "_comment": "SDD methodology layer"
    },
    {
      "path": "~/.gemini/config/plugins/<stack-name>-stack",
      "_comment": "Technology layer for <stack>"
    }
  ]
}
```

---

## Separation of Concerns

| Belongs in `sdd-scaffold-plugin` | Belongs in a Stack Skill |
|---|---|
| SDD lifecycle rules | Project structure conventions |
| Approval gate enforcement | Test framework setup |
| Spec/plan/tasks/walkthrough templates | Code style and naming conventions |
| Subagent personas | Framework-specific patterns and examples |
| Agentic RAG conventions | Stack-specific security checks |
| `stack-contract` interface definition | `sdd_stack_contract` implementation |

**Do NOT put methodology rules in stack skills.** Do NOT put framework code in `sdd-scaffold-plugin`.

---

## Publishing

Stack skills can be:
1. **Personal** — installed globally at `~/.gemini/config/plugins/<name>`.
2. **Team** — checked into a shared team repository and referenced via `plugins.json` path.
3. **Community** — published to GitHub following the `agentskills.io` open standard and referenced by others.

When publishing to the community, use the skill name prefix `sdd-<stack>-stack` to make discoverability clear (e.g., `sdd-spring-boot-stack`, `sdd-nextjs-stack`).

---

## Questions

Open an issue in the `sdd-scaffold-plugin` repository with the `stack-skill` label.

