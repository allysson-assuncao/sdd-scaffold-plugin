# Tasks: Tech Research and Discovery Alignment Capabilities

> **Change ID:** `feat-tech-research-and-discovery`
> **Linked Proposal:** [proposal.md](./proposal.md)
> **Status:** completed
>
> All tasks must be `[x]` before this change can be archived via `sdd-spec-archive`.

---

## Implementation Tasks

- [x] **T-01:** Create `agents/tech-profiler.md` with `subagent: true`, `mainAgent: false`, `model: flash`, `commandExecutionPolicy: sandbox`, and canonical read-only tools (`read_file`, `grep_search`, `find_by_name`, `list_dir`, `send_message`) to profile workspace manifests and `sdd-stack-contract.md`.
- [x] **T-02:** Create `skills/tech-research/SKILL.md` and `skills/tech-research/resources/tech-decision-template.md` implementing the `tech-profiler` -> `search_web` -> 2–4 options comparison -> `/grill-me` -> on-demand persistence (`sdd-stack-contract.md` / `sdd-spec-create` or `tech-decision-<topic>.md`) workflow.
- [x] **T-03:** Create `skills/discovery-align/SKILL.md` and `skills/discovery-align/resources/discovery-report-template.md` implementing the `sdd-code-explorer` / `research` -> 2–3 initial solution proposals -> `/grill-me` -> on-demand handoff (`sdd-spec-create` or `discovery-<topic>.md` / direct execution) workflow.
- [x] **T-04:** Update `skills/sdd-prompt-craft/SKILL.md` and `skills/sdd-prompt-craft/resources/prompt-guide.md` to disambiguate offline `prompt-*.md` generation from live interactive `discovery-align` and `tech-research` workflows.

## Security Validation Tasks

- [x] **T-05:** Verify `agents/tech-profiler.md` includes explicit constraints against reading or outputting `.env`, credentials, or private keys, and declares zero write or shell execution tools.
- [x] **T-06:** Verify `skills/tech-research/SKILL.md` and `skills/discovery-align/SKILL.md` enforce `kebab-case` validation on `<topic>` report filenames and include security/maintenance evaluation criteria for external libraries.

## Test Tasks

- [x] **T-07:** Update `validate-v3.sh` to validate `skills/tech-research/SKILL.md`, `skills/discovery-align/SKILL.md`, their `resources/*.md` templates, and `agents/tech-profiler.md` frontmatter/tool invariants.
- [x] **T-08:** Run `bash validate-v3.sh` and `agy plugin validate .` and confirm `skills 14 · agents 4` pass with 0 errors.

## Documentation Tasks

- [x] **T-09:** Update root `README.md` to document `tech-research`, `discovery-align`, and `tech-profiler` with usage examples for both SDD and non-SDD projects.

## Review Gate

- [x] All implementation tasks complete
- [x] All security validation tasks complete
- [x] All tests passing (`bash validate-v3.sh` and `agy plugin validate .`)
- [x] Proposal acceptance criteria verified (run `sdd-spec-validate`)
- [x] Ready for `sdd-spec-archive`
