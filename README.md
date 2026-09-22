# `sdd-scaffold-plugin`

> **A global Antigravity plugin that enforces Spec-Driven Development (SDD) across any software project.**

This plugin transforms your AI pair programmer from a free-form assistant into a disciplined, specification-first engineering partner. It enforces the full SDD lifecycle with approval gates, TDD discipline, structured Agentic RAG artifacts, and automated audit subagents.

---

## Installation

Copy this repository to your global Antigravity plugins directory:

```bash
# Unix / macOS
cp -r sdd-scaffold-plugin ~/.gemini/config/plugins/sdd-scaffold-plugin

# Windows (PowerShell)
Copy-Item -Recurse sdd-scaffold-plugin "$env:USERPROFILE\.gemini\config\plugins\sdd-scaffold-plugin"
```

The plugin is automatically discovered by Antigravity on next launch.

---

## Quick Start: New Project

1. Open your project in Antigravity.
2. Activate the `sdd-init` skill: _"Initialize SDD for this project"_
3. Answer 4 questions (project name, stack, governance mode, specs directory).
4. Your `.agents/` scaffold and `specs/` directory are created.
5. Begin your first feature with `spec-architect`.

---

## The SDD Lifecycle

```
Constitution → Specification → [Gate 1] → Planning → [Gate 2] → TDD Implementation → Verification & Audit
```

| Phase | Skill | Gate | Subagents |
|---|---|---|---|
| Specification | `spec-architect` | Gate 1 (APPROVED) | `spec-reviewer` |
| Planning | `implementation-planner` | Gate 2 (APPROVED) | — |
| TDD Implementation | `tdd-enforcer` | — | `test-runner` |
| Verification | (end of `tdd-enforcer`) | — | `security-auditor`, `dependency-auditor` |
| Full end-to-end | `sdd-cycle-orchestrator` | Both gates | All four |

---

## Plugin Contents

```text
sdd-scaffold-plugin/
├── plugin.json                              # Plugin manifest
├── AGENTS.md                                # Global agent constitution
├── rules/                                   # Always-on governance rules
│   ├── 00-sdd-constitution.md               # Non-negotiable SDD guardrails
│   ├── 01-approval-gates.md                 # Gate 1 & Gate 2 enforcement
│   ├── 02-artifact-schema.md                # YAML front-matter schema (Agentic RAG)
│   └── 03-agentic-rag.md                    # Self-indexing & cross-referencing
├── skills/
│   ├── sdd-init/                            # Project scaffolding skill
│   ├── spec-architect/                      # Specification phase skill
│   ├── implementation-planner/              # Planning phase skill
│   ├── tdd-enforcer/                        # TDD implementation skill
│   ├── sdd-cycle-orchestrator/              # Full lifecycle orchestrator
│   └── stack-contract/                      # Stack plug-in interface contract
├── agents/
│   ├── spec-reviewer.md                     # Validates spec completeness
│   ├── security-auditor.md                  # OWASP Top 10 static scan
│   ├── test-runner.md                       # Runs tests, returns failures only
│   └── dependency-auditor.md                # CVE and dependency scan
├── mcp_config.json                          # Optional MCP (disabled by default)
└── docs/
    └── CONTRIBUTING.md                      # Stack plug-in authoring guide
```

---

## Agentic RAG

All SDD artifacts use a **YAML front-matter schema** that forms a self-referencing knowledge graph — no external vector database required:

```yaml
---
id: feat-auth-spec
type: spec
status: approved
feature: User Authentication
depends_on: []
verified_by: [feat-auth-walkthrough]
tags: [auth, security, backend]
created_at: 2026-09-22
updated_at: 2026-09-22
---
```

Agents traverse `depends_on` and `verified_by` chains to reconstruct full feature histories and use `tags` for cross-feature RAG queries.

---

## Extending with Stack Skills

The plugin is stack-agnostic by design. Add technology-specific patterns via compatible stack skills:

1. Read `skills/stack-contract/SKILL.md` to understand the interface.
2. Copy `skills/stack-contract/resources/stack-skill-template/SKILL.md.tmpl`.
3. Implement the three hooks: `test_command`, `lint_command`, `setup_command`.
4. Register in your project's `.agents/plugins.json`.

See [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) for the full guide.

---

## Per-Project Override

Any rule or behavior can be overridden at the project level:

```
.agents/
├── plugins.json          # References this global plugin
├── AGENTS.md             # Project-specific overrides (highest priority)
└── rules/
    └── local.md          # Project-specific additional rules
```
