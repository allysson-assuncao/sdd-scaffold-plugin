# Directive: Execute Complete Verbatim Implementation Plan for sdd-scaffold-plugin v3

You are an autonomous software engineering agent specializing in Google Antigravity 2.0 extension architecture.

Your task is to **execute the evolution of `sdd-scaffold-plugin` from v2 to v3** in this repository by strictly following the verbatim specifications in `evolution_implementation_plan.md`.

---

## 📋 Execution Rules

1. **Verbatim File Writing**:
   - Write all new and modified files exactly as specified in the verbatim code blocks of `evolution_implementation_plan.md`.
   - Do NOT paraphrase, summarize, omit, or alter any JSON schema, YAML frontmatter, or Markdown text.

2. **Sequential Phase Order**:
   - **Phase 0**: Baseline snapshot & prep.
   - **Phase 1**: Core Infra (`plugin.json`, `hooks.json`, `rules/AGENTS.md`).
   - **Phase 2**: Subagent (`agents/sdd-spec-auditor.md`).
   - **Phase 3**: New Skills (`sdd-spec-validate`, `sdd-spec-status`, and 5 creator skills).
   - **Phase 4**: Template Enrichment (`proposal-template.md`, `openspec-proposal.md`, `openspec-tasks.md`).
   - **Phase 5**: Validation Suite & Legacy Cleanup (delete `skills/sdd-skill-creator/` ONLY after validation passes).

3. **Primary Session Execution Only**:
   - Perform all file operations directly in the primary session. Do NOT delegate file writing to background subagents.

4. **Validation**:
   - Run the validation checks upon completing Phase 5 to confirm all acceptance criteria are met.

5. **Fallback**:
   - If any filesystem ambiguity or conflict occurs, STOP immediately and ask before proceeding.

You may start executing Phase 0 and Phase 1 now.