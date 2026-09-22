# Artifact Schema — YAML Front-Matter Standard

All SDD artifacts MUST begin with a valid YAML front-matter block. This schema enables **Agentic RAG** — agents can traverse the knowledge graph formed by `id`, `depends_on`, and `verified_by` fields without any external vector database.

---

## Required Schema

Every `spec.md`, `implementation_plan.md`, `tasks.md`, and `walkthrough.md` MUST open with the following block:

```yaml
---
id: <kebab-case-unique-id>
type: spec | plan | tasks | walkthrough
status: draft | in-review | approved | done
feature: <feature or module name>
depends_on: []
verified_by: []
tags: []
created_at: YYYY-MM-DD
updated_at: YYYY-MM-DD
---
```

---

## Field Reference

| Field | Required | Description |
|---|---|---|
| `id` | ✅ | Globally unique identifier for this artifact. Use kebab-case. Convention: `<feature>-<type>` (e.g., `user-auth-spec`, `user-auth-plan`). |
| `type` | ✅ | One of: `spec`, `plan`, `tasks`, `walkthrough`. |
| `status` | ✅ | Lifecycle state. Must be updated as the artifact progresses. |
| `feature` | ✅ | Human-readable name of the feature or module this artifact belongs to. |
| `depends_on` | ✅ | List of `id` values of artifacts this document depends on. Empty list `[]` if none. |
| `verified_by` | ✅ | List of `id` values of artifacts or test file paths that verify this artifact's correctness. Empty list `[]` if none yet. |
| `tags` | ✅ | Free-form keyword list for cross-document RAG queries (e.g., `[auth, breaking-change, backend]`). |
| `created_at` | ✅ | ISO 8601 date (YYYY-MM-DD) of artifact creation. |
| `updated_at` | ✅ | ISO 8601 date (YYYY-MM-DD) of last modification. Must be updated on every edit. |

---

## Status Lifecycle

```
draft → in-review → approved → done
```

- **`draft`**: Artifact is being authored. May be incomplete.
- **`in-review`**: Artifact has been presented for Gate approval or subagent review.
- **`approved`**: User has explicitly approved the artifact (Gate passed).
- **`done`**: All tasks in this artifact are complete and verified.

---

## Example: Complete `spec.md` Front-Matter

```yaml
---
id: user-auth-spec
type: spec
status: approved
feature: User Authentication
depends_on: []
verified_by: [user-auth-walkthrough]
tags: [auth, security, backend, api]
created_at: 2026-09-22
updated_at: 2026-09-22
---
```

---

## Validation Rules

- `id` must be unique across all artifacts in the project's `specs/` directory.
- `depends_on` values must reference existing artifact `id`s. If a referenced artifact does not exist, flag it as an open dependency before proceeding.
- `updated_at` must be refreshed every time the artifact body is modified.
- A `spec.md` with `status: draft` or `in-review` MUST NOT have a corresponding `implementation_plan.md` generated yet.

