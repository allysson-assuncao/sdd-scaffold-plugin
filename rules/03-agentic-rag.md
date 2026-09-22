# Agentic RAG — Self-Indexing & Cross-Referencing Conventions

These conventions ensure that all SDD artifacts form a **traversable knowledge graph**, enabling agents to answer cross-document questions, detect conflicts, and build context without external vector databases.

---

## 1. Always Reference by `id`, Never by File Path

When one artifact depends on another, use the target's `id` field — not a relative file path. File paths change; `id`s are stable.

✅ Correct:
```yaml
depends_on: [user-auth-spec]
verified_by: [user-auth-walkthrough, tests/auth/test_login.py]
```

❌ Incorrect:
```yaml
depends_on: [../specs/user-auth-spec.md]
```

---

## 2. Pre-Planning RAG Query (Mandatory)

Before generating any `spec.md` or `implementation_plan.md`, **always search the project's `specs/` directory** for artifacts with matching `tags` or `feature` values. This prevents:
- Duplicate specifications for the same feature.
- Conflicting plans that contradict existing approved specs.

Search pattern: scan all `*.md` files in `specs/` and read their YAML front-matter `id`, `feature`, `tags`, and `status` fields.

If a conflict is found, surface it to the user before proceeding:
> _"I found an existing spec `[id]` tagged `[tags]` with status `[status]`. Should I extend it, replace it, or create a separate artifact?"_

---

## 3. Status Propagation Rules

When an artifact changes status, propagate the update to linked artifacts:

| Event | Action |
|---|---|
| A task is marked `[x]` in `tasks.md` | Update `updated_at` in the parent `implementation_plan.md` |
| All tasks in `tasks.md` are `[x]` | Set `tasks.md` `status` to `done`; update `implementation_plan.md` `status` to `done` |
| A `walkthrough.md` is completed | Add its `id` to `verified_by` in the corresponding `spec.md`, `plan.md`, and `tasks.md` |
| A spec is revised after approval | Reset `status` to `draft`; notify user that Gate 1 must be re-passed |

---

## 4. Knowledge Graph Traversal Pattern

The standard artifact chain for a single feature forms a directed acyclic graph (DAG):

```
spec.md (root)
  └─ depends_on: []
  └─ verified_by: [walkthrough.md]

plan.md
  └─ depends_on: [spec.md.id]
  └─ verified_by: [tasks.md.id]

tasks.md
  └─ depends_on: [plan.md.id]
  └─ verified_by: [walkthrough.md.id]

walkthrough.md (leaf)
  └─ depends_on: [tasks.md.id]
  └─ verified_by: []
```

To reconstruct the full feature history, traverse: `spec → plan → tasks → walkthrough`.

---

## 5. Cross-Feature Queries via `tags`

The `tags` field enables horizontal queries across features. Use consistent, lowercase, hyphenated tags.

**Recommended standard tags:**

| Tag | When to use |
|---|---|
| `breaking-change` | This feature changes public APIs or data contracts |
| `security` | This feature touches authentication, authorization, or encryption |
| `performance` | This feature has explicit performance targets |
| `backend` | Server-side only |
| `frontend` | Client-side only |
| `full-stack` | Both sides |
| `database` | Involves schema changes or migrations |
| `api` | Exposes or modifies API endpoints |
| `infrastructure` | CI/CD, deployment, containerization |

---

## 6. Artifact Discovery Protocol

When starting any SDD work session in an existing project, perform this discovery sequence:

1. List all `*.md` files under `specs/`, `plans/`, and `tasks/` directories.
2. Read YAML front-matter only (stop at the `---` closing delimiter).
3. Build a working mental index: `{ id → { type, status, feature, tags, depends_on } }`.
4. Report to the user: _"Found [N] existing specs: [list with id and status]. Which feature should we work on?"_

