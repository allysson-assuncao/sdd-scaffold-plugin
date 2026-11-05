# Bugfix Proposal: [Change Title]

> **Change ID:** `<NNN-fix-change-id>`
> **Execution Order:** `NNN`
> **Type:** Bugfix & Legacy Adaptation
> **Priority:** <!-- Critical / High / Medium / Low -->
> **Status:** draft
> **Created:** YYYY-MM-DD
> **Last Updated:** YYYY-MM-DD

---

## Summary

<!-- One paragraph summarizing the bug cluster, why these issues were grouped together, and what the fix accomplishes. -->

## Grouped Bugs & Symptoms

- **Bug 1:** <!-- Original bug description and observed symptom -->
- **Bug 2:** <!-- Original bug description and observed symptom -->

## Root Cause Analysis (Causa Raiz)

<!-- Detailed technical explanation of WHY each bug happens in the current codebase.
     Reference exact classes, methods, SQL queries, state hooks, or missing domain logic. -->

## Systemic Ripple Effects & Similar Latent Bugs (Repercussão no Código)

<!-- Document other places in the codebase that share the same pattern or vulnerability.
     Explain whether they are also broken and how this change addresses them to prevent discrepancies. -->

## Legacy Code & Data Adaptation Strategy (Adequação de Legado)

<!-- MANDATORY FOR BUGFIXES:
     1. How are existing database records, Flyway seed data, or saved client states affected?
     2. What Flyway migrations (e.g., V<X>__*.sql) or data backfills are needed so legacy entities (items, feats, characters, users) behave identically to newly created ones?
     3. What defensive fallbacks are required in domain/application mappers for backwards compatibility? -->

### Legacy Impact Matrix
| Legacy Artifact / Table | Discrepancy Identified | Adaptation / Migration Action |
|-------------------------|------------------------|-------------------------------|
| `table_or_seed_file` | <!-- e.g., Missing active mechanics JSON --> | <!-- e.g., Flyway migration V25 to backfill mechanics --> |

## Scope

### In Scope
- <!-- List every fix, refactor, and legacy data migration included in this change. -->

### Out of Scope
- <!-- List related items intentionally deferred or handled in other clusters. -->

## Proposed Solution

### Technical Approach
<!-- Describe the architectural and implementation solution across domain, application, persistence, and frontend layers. -->

### Impacted Files
<!-- Populated by sdd-code-explorer subagent. -->
| File | Change Type | Notes |
|------|-------------|-------|
| `path/to/file` | Modify | <!-- brief note --> |
| `path/to/migration.sql` | Create | <!-- brief note --> |

### Data Model & API Changes (if applicable)
<!-- Describe schema alterations, Flyway migrations, DTO changes, or REST contract updates. -->

## Acceptance Criteria

<!-- Each criterion MUST follow Given-When-Then format and cover both fresh data and legacy data scenarios. -->
- [ ] **Given** <!-- context --> **When** <!-- action --> **Then** <!-- expected result -->
- [ ] **Given** a legacy record created prior to this fix **When** <!-- action --> **Then** <!-- expected result without discrepancy -->

## Defensive Security & Validation Considerations

### Input Validation
- <!-- Jakarta Validation / Zod schema rules enforced on modified endpoints/forms. -->

### Secret Isolation
- <!-- Confirm no credentials, tokens, or keys are hardcoded. -->

### Authorization & Authentication Impact
- <!-- Describe access control checks (e.g., Campaign DM vs Player permissions, Auth token lifecycle). -->

### Other Security Risks
- <!-- State manipulation, IDOR, injection vectors, or race conditions in state updates. -->

## Testing Strategy & Shift-Left Plan

### Regression & Happy Path Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TR-01 | <!-- Exact reproduction of reported bug now passing --> | Unit / Integration / E2E | <!-- Expected outcome --> |
| TR-02 | <!-- Verification on legacy seed/migrated data --> | Integration | <!-- Expected outcome --> |

### Edge Case & Failure Mode Tests
| Test ID | Scenario | Test Type | Expected Result |
|---------|----------|-----------|-----------------|
| TE-01 | <!-- Boundary value, invalid slot, zero charges, etc. --> | Unit / Integration | <!-- Expected outcome --> |

### Test Commands
- **Backend tests:** `mvn clean test`
- **Frontend tests:** `npm test`

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| <!-- e.g., Existing characters lose equipped armor during slot migration --> | Med | High | <!-- Map existing equipped armor to CHEST slot in Flyway migration --> |

## Specification Changes & Delta Stubs

### `specs/<spec-name>-delta.md`
- **Target Canonical Spec:** `openspec/specs/<target>.md`
- **Summary of Updates:** <!-- Summary of canonical spec updates -->
