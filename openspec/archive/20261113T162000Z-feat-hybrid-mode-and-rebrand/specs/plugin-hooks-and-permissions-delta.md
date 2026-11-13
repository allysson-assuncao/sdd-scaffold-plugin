# Delta Spec: `plugin-hooks-and-permissions`

> **Change ID:** `feat-hybrid-mode-and-rebrand`
> **Target Canonical Spec:** `openspec/specs/plugin-hooks-and-permissions.md`
> **Change Type:** Modify

## Architectural Updates

- **Update Plugin Identifier:** References to `sdd-scaffold-plugin` in the specification context are updated to `agentic-dev-workflow`.
- **Update `[RF-05]` Opt-In SDD Governance Hook Recipes (`sdd-enforce-proposal`):**
  - `scripts/check-approved-proposal.mjs` MUST first inspect whether the `openspec/` directory exists in `workspaceRoot`.
  - When `openspec/` does NOT exist (non-SDD or legacy workspace), `scripts/check-approved-proposal.mjs` MUST fail open and output `{}` (pass-through) so file mutations are never blocked in non-SDD projects.
  - When `openspec/` DOES exist, `scripts/check-approved-proposal.mjs` MUST continue to allow writes targeting `openspec/` or `.agents/` and deny writes to other workspace paths unless at least one `openspec/changes/<id>/proposal.md` contains `**Status:** approved`.
