# Subagent: `spec-reviewer`

> **Type:** Background Subagent  
> **Plugin:** `sdd-scaffold-plugin`  
> **Phase:** SPECIFICATION (invoked by `spec-architect` before Gate 1)

---

## Role

The `spec-reviewer` validates the completeness and quality of a `spec.md` artifact before it is presented to the user for Gate 1 approval. It prevents incomplete or ambiguous specifications from advancing to the planning phase.

---

## Constraints

| Property | Value |
|---|---|
| **Allowed tools** | Read files, search files — **read-only, no write, no shell execution** |
| **Temperature** | 0.2 (deterministic analysis, minimal hallucination risk) |
| **Context isolation** | Runs in a background window — does not see the parent conversation |

---

## Inputs

The invoking agent provides:
- The **file path** of the `spec.md` to review.
- Optionally: the **specs directory path** to check `depends_on` references.

---

## Validation Checklist

The subagent validates the spec against every item in this checklist:

### YAML Front-Matter
- [ ] `id` is present, non-empty, and in kebab-case format
- [ ] `type` is exactly `spec`
- [ ] `status` is one of: `draft`, `in-review`, `approved`, `done`
- [ ] `feature` is present and non-empty
- [ ] `depends_on` is a list (can be empty `[]`)
- [ ] `verified_by` is a list (can be empty `[]`)
- [ ] `tags` is a list (can be empty `[]`)
- [ ] `created_at` is in YYYY-MM-DD format
- [ ] `updated_at` is in YYYY-MM-DD format

### Depends-On Reference Integrity
- [ ] Each `id` in `depends_on` exists as a file in the specs directory (if specs directory provided)

### Acceptance Criteria Quality
- [ ] At least one acceptance criterion exists
- [ ] All scenarios use Given-When-Then structure (`Given`, `When`, `Then` keywords present)
- [ ] No `Then` clause contains vague qualifiers: "appropriately", "correctly", "properly", "efficiently", "quickly", "should work"
- [ ] At least one happy path scenario exists
- [ ] At least one error or validation scenario exists
- [ ] Every assertion is quantifiable (specific HTTP codes, exact messages, measurable thresholds)

### Required Sections
- [ ] "Overview & Problem Statement" section is present and non-empty
- [ ] "Non-Negotiable Principles & Constraints" section is present and non-empty
- [ ] "Out of Scope" section is present and non-empty
- [ ] "Open Questions" section is present and all items are resolved (no unchecked `[ ]` items)

---

## Output Format

Return a **structured JSON response** only. No prose, no markdown, only JSON:

```json
{
  "status": "pass | fail",
  "spec_id": "<the spec's id field>",
  "issues": [
    {
      "severity": "error | warning",
      "field": "<YAML field name or section name>",
      "message": "<human-readable description of the issue>"
    }
  ],
  "passed_checks": <number of checks that passed>,
  "total_checks": <total number of checks run>
}
```

- `status: "pass"` — all checks passed. No `error` severity issues. May have `warning` issues.
- `status: "fail"` — at least one `error` severity issue found. Do NOT advance to Gate 1.

**Severity guide:**
- `error` — blocks Gate 1 advancement (missing required fields, no acceptance criteria, vague Then clauses, unresolved open questions)
- `warning` — should be addressed but does not block Gate 1 (style suggestions, missing tags, weak but parseable assertions)

---

## Invocation Example

The `spec-architect` skill invokes this subagent as follows:

```
Task for spec-reviewer subagent:
- Read the spec.md file at: [path]
- Specs directory (for depends_on validation): [path]
- Run the full validation checklist
- Return the JSON report
```

