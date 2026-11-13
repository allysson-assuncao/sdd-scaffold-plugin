# agentic-dev-workflow (v4.0.0)

> Adaptive Agentic Software Development & Spec-Driven Development (SDD) workflow plugin for **Google Antigravity 2.0**.

`agentic-dev-workflow` (formerly `sdd-scaffold-plugin`) provides a complete, structured engineering lifecycle for AI agents—combining **Dual-Mode Governance** (strict SDD when `openspec/` is present; lightweight opt-out in simple or legacy projects), **modular `.agents/` artifact creators**, **prompt engineering automation**, and **safe read-only subagent delegation**.

---

## Key Features & Dual-Mode Governance

The global rule in [`rules/AGENTS.md`](./rules/AGENTS.md) automatically adapts to each workspace:

1. **Strict SDD Mode (`openspec/` present in workspace):**
   - Enforces the **Spec-First Mandate**: no structural code changes occur before an active change proposal (`openspec/changes/<change-id>/proposal.md`) is approved by the user and audited via `sdd-spec-validate`.
   - Enforces **Canonical Living Specs** (`openspec/specs/` never contains `*-delta.md` files; deltas are semantically merged on `sdd-spec-archive`).
2. **Adaptive Non-SDD Mode (`openspec/` absent in workspace):**
   - For simple, exploratory, or legacy projects without `openspec/`, the agent recommends SDD for large structural changes but **respects explicit user opt-out** to proceed directly with implementation or lightweight decision reports without blocking writes.
3. **Universal Subagent Delegation (Both Modes):**
   - Prevents main-session context bloat by delegating codebase impact scans to `sdd-code-explorer` and broad cross-cutting exploration to `research`.

---

## Bundled Customizations

### 1. Interactive Discovery & Technology Research Skills (SDD & Non-SDD)
| Skill | Description |
|-------|-------------|
| `tech-research` | Profiles local stack constraints via `tech-profiler`, researches market standards and reference architectures via `search_web`, presents 2–4 candidate options, aligns via `/grill-me`, and updates `sdd-stack-contract.md` or writes `tech-decision-<topic>.md` on demand. |
| `discovery-align` | Investigates workspace context via `sdd-code-explorer` / `research`, proposes 2–3 initial solution approaches with trade-offs in chat, aligns open decisions via `/grill-me`, and hands off to `sdd-spec-create` or writes `discovery-<topic>.md` on demand. |

### 2. SDD Lifecycle Skills (`skills/sdd-*`)
| Skill | Description |
|-------|-------------|
| `sdd-init` | Initializes `.agents/` and `openspec/` (`specs/`, `changes/`, `archive/`, `sdd-stack-contract.md`). |
| `sdd-spec-create` | Scaffolds `openspec/changes/<change-id>/` (`proposal.md`, `tasks.md`, `specs/`) and runs `sdd-code-explorer`. |
| `sdd-bug-triage` | Clusters QA/bug reports by root cause, analyzes blast radius & migrations, and scaffolds prioritized fix proposals. |
| `sdd-spec-validate` | Runs pre-implementation audit via `sdd-spec-auditor` (`Approved`, `Approved with Reservations`, `Rejected`). |
| `sdd-spec-status` | Renders a live progress dashboard of active changes in `openspec/changes/`. |
| `sdd-spec-archive` | Enforces 100% `[x]` task completion, merges delta specs into `openspec/specs/`, and archives the change. |

### 3. Prompt Engineering Workflow
| Skill / Subagent | Description |
|------------------|-------------|
| `sdd-prompt-craft` | Gathers user intent and delegates to `sdd-prompt-architect` to generate standalone, token-efficient `prompt-*.md` files in the project root for external/subsequent execution models. |
| `sdd-prompt-architect` | Sandboxed `flash` subagent selecting among 4 templates (Discovery `/grill-me`, SDD Spec, Phased Execution with `walkthrough.md`, Direct Fix). |

### 4. Modular `.agents/` Creators
| Skill | Description |
|-------|-------------|
| `sdd-skill-create` | Scaffolds a new Antigravity 2.0 Skill (`SKILL.md` + optional subdirectories). |
| `sdd-rule-create` | Scaffolds or appends behavioral rules (`AGENTS.md`) within the 50-line budget. |
| `sdd-agent-create` | Scaffolds least-privilege subagents (`agents/<name>.md`) using canonical tool names. |
| `sdd-hook-create` | Configures lifecycle hooks in `hooks.json` (`map[string]JSONHookSpec`) with portable `.mjs` scripts. |
| `sdd-mcp-create` | Scaffolds `stdio` or `SSE` MCP server entries in `mcp_config.json` with environment variable secret injection. |

### 5. Subagents (`agents/`)
- **`tech-profiler`** (`flash`, `sandbox`, read-only): Profiles project manifests (`package.json`, `pom.xml`, `pyproject.toml`, Dockerfiles, `sdd-stack-contract.md`) and architectural constraints for `tech-research`.
- **`sdd-code-explorer`** (`flash`, `sandbox`, read-only): Scans repository files, symbols, and routes to map change or discovery impact.
- **`sdd-spec-auditor`** (`flash`, `sandbox`, read-only): Audits `proposal.md` and `tasks.md` for Given-When-Then criteria, security, and shift-left test plans.
- **`sdd-prompt-architect`** (`flash`, `sandbox`): Generates structured English `prompt-*.md` files in the workspace root.

### 6. Lifecycle Hooks (`hooks.json` & `scripts/`)
- **`sdd-readonly-auto-allow`** (`enabled: true`): Automatically approves safe read-only tool calls and non-destructive inspection commands (`git status/log/diff`, `agy plugin validate`) while guarding sensitive paths (`.env`, `.ssh`, private keys).
- **`sdd-enforce-proposal`** (`enabled: false`, opt-in): Denies code writes in SDD workspaces (`openspec/` present) unless an approved `proposal.md` exists; passes through (`{}`) in non-SDD workspaces.
- **`sdd-scope-prompt-writes`** (`enabled: false`, opt-in): Restricts `sdd-prompt-architect` writes strictly to root `prompt*.md` files.
- **`sdd-run-linter`** (`enabled: false`, opt-in): Post-write linter hook stub.

---

## Installation & Upgrade

Validate and install globally using the Antigravity CLI:

```bash
# 1. Validate plugin manifest, skills, agents, rules, and hooks
agy plugin validate .

# 2. Run the acceptance test suite
bash validate-v3.sh

# 3. Install globally into ~/.gemini/config/plugins/
agy plugin install .
```

> **Upgrading from `sdd-scaffold-plugin` (v3.x):**
> Because the plugin identifier in `plugin.json` changed from `sdd-scaffold-plugin` to `agentic-dev-workflow`, remove the legacy `~/.gemini/config/plugins/sdd-scaffold-plugin` directory after installing `agentic-dev-workflow` so rules and skills are not loaded twice.

---
