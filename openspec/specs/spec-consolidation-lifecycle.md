# Specification: Spec Consolidation & Delta Merge Lifecycle

> **Spec ID:** `spec-consolidation-lifecycle`
> **Title:** Specification Lifecycle, Canonical Living Specs & Delta Consolidation
> **Version:** 1.0.0
> **Status:** active
> **Owners:** @sdd-team
> **Scope:** Defines the lifecycle stages of SDD specifications, delta scoping within change proposals, and consolidation rules during archival.
>
> This is the authoritative source of truth for this module's current functional state.
> Update this file only after merging a completed change from openspec/changes/.

---

## 1. Overview

In Spec-Driven Development (SDD), specifications serve as the single source of truth for the system's architecture, APIs, data contracts, and functional behaviors. To maintain high architectural fidelity without documentation rot, specifications follow a strict lifecycle that separates transient change deltas from permanent canonical living documentation.

## 2. Specification Directory Structure & Invariants

### 2.1 Namespace Roles
1. `openspec/changes/<change-id>/specs/` (Transient Change Scope):
   - Contains temporary specifications and deltas scoped to an active change.
   - May contain delta files (e.g., `specs/<target>-delta.md`) or brand-new subsystem specifications (e.g., `specs/<new-module>.md`).
   - Files here are mutable and evolve during proposal drafting and implementation.
2. `openspec/specs/` (Canonical Living Documentation):
   - The authoritative, consolidated repository of current architectural specifications.
   - **Canonical Invariant:** Every file in this directory must represent the consolidated, up-to-date state of a domain or subsystem conforming to `spec-template.md`.
   - **Prohibition:** Files with the suffix `-delta.md` are STRICTLY FORBIDDEN in `openspec/specs/`.
3. `openspec/archive/<timestamp>-<change-id>/` (Immutable Audit Trail):
   - Once a change is fully implemented and all tasks are checked, the entire change directory (including its proposal, tasks, and original deltas) is permanently moved here.
   - Preserves complete historical context of what changed in each phase.

## 3. Specification Lifecycle Workflow

### 3.1 Creation (`sdd-spec-create`)
- When creating a change proposal, code impact analysis maps affected source files to architectural domain specifications.
- If the change modifies existing canonical specifications, a delta specification stub (`specs/<domain>-delta.md`) is created within `openspec/changes/<change-id>/specs/`, identifying the target canonical spec (`Target: openspec/specs/<domain>.md`).
- If the change introduces a brand-new subsystem or architectural domain, a new specification (`specs/<new-domain>.md`) is scaffolded directly in canonical format (without `-delta` suffix).

### 3.2 Archival & Consolidation (`sdd-spec-archive`)
- When closing a completed change:
  1. **New Specifications:** Any file in `changes/<change-id>/specs/` that represents a new subsystem (and is not named `*-delta.md`) is moved/copied to `openspec/specs/<filename>.md`.
  2. **Delta Specifications:** For any file ending in `-delta.md`, the agent reads the delta content and the corresponding canonical living spec in `openspec/specs/<target>.md`. The agent semantically merges functional changes, contracts, and requirements, increments the version (`version: X.Y.Z`), and writes the consolidated result back to `openspec/specs/<target>.md`.
  3. **Verification Guard:** A strict verification check confirms that no file matching `*-delta.md` exists in `openspec/specs/`.
  4. **Archival Movement:** The change directory is moved to `openspec/archive/<timestamp>-<change-id>/`.

## 4. Requirements

### 4.1 Functional Requirements (RF)
- **RF-01 (Canonical Purity):** `openspec/specs/` must reject any file containing `-delta.md`.
- **RF-02 (Semantic Consolidation):** Archiving a change must merge delta content into target canonical living specs rather than copying delta files.
- **RF-03 (Version Increment):** Updating a canonical living spec during consolidation must increment its semantic version.
- **RF-04 (Archival Preservation):** The raw delta specs must be retained in `openspec/archive/` alongside the original proposal and task list.

### 4.2 Non-Functional Requirements (RNF)
- **RNF-01 (Rule Budget):** Enforcement rules in `rules/AGENTS.md` must fit within the 55-line global budget limit.
- **RNF-02 (Zero External Migration Burden):** The plugin engine shall not require backward-compatibility migration shims or legacy cleanup logic for external repositories.
