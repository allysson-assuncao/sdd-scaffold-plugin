# Proposal: [Change Title]

> **Change ID:** `<change-id>`
> **Status:** draft
> **Author:** <!-- @handle or full name -->
> **Created:** YYYY-MM-DD
> **Last Updated:** YYYY-MM-DD

---

## Summary

<!-- One paragraph. What does this change do? Why is it needed?
     Be specific enough that a reviewer who doesn't know the context can understand. -->

## Motivation

<!-- What problem does this solve?
     - Reference user pain points, bug reports, or product requirements.
     - Include links to issues, tickets, Slack threads, or ADRs if applicable. -->

## Scope

### In Scope
- <!-- List every deliverable explicitly included in this change. -->

### Out of Scope
- <!-- List items that might seem related but are NOT part of this change. -->
  <!-- Being explicit here prevents scope creep during implementation. -->

## Proposed Solution

### Approach
<!-- Describe the technical approach in 2-4 paragraphs.
     Cover: what will be created/modified/deleted, why this approach was chosen,
     and any significant trade-offs. -->

### Impacted Files
<!-- List files identified by sdd-code-explorer or manual analysis. -->
| File | Change Type | Notes |
|------|-------------|-------|
| `path/to/file.ts` | Modify | <!-- brief note --> |
| `path/to/new-file.ts` | Create | <!-- brief note --> |

### Data Model Changes (if applicable)
<!-- Describe any changes to database schemas, API contracts, or shared types. -->

## Acceptance Criteria

<!-- Written as verifiable conditions. Each criterion must be testable. -->
- [ ] **Given** <!-- context --> **When** <!-- action --> **Then** <!-- expected result -->
- [ ] <!-- Criterion 2 -->
- [ ] <!-- Criterion 3 -->

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| <!-- Describe risk --> | Low / Med / High | Low / Med / High | <!-- How to mitigate --> |

## Delta Spec Stubs

<!-- One section per impacted file. The sdd-code-explorer subagent can generate these. -->

### `specs/<filename>-delta.md`
<!-- What changes in this file specifically. Include: function signatures,
     new types, removed fields, new endpoints, etc. -->

## References

- <!-- Link to related spec, ADR, or documentation -->
- <!-- Link to issue tracker ticket -->
