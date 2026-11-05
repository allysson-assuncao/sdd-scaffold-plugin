# Delta Spec: `agent-sdd-prompt-architect`

> **Change ID:** `feat-hooks-and-readonly-permissions`
> **Target Canonical Spec:** `openspec/specs/agent-sdd-prompt-architect.md`
> **Change Type:** Modify

## Architectural Updates

### Section 2: Frontmatter Contract
Update the `tools:` list in the YAML frontmatter contract of `sdd-prompt-architect` to explicitly include Antigravity 2.0's complete read/write/messaging tool identifiers:
```yaml
tools:
  - view_file
  - read_file
  - grep_search
  - find_by_name
  - list_dir
  - write_to_file
  - write_file
  - invoke_subagent
  - send_message
```

### Section 3: Operational Requirements
- Update **Tooling Restrictions** to list read tools (`view_file`, `read_file`, `grep_search`, `find_by_name`, `list_dir`), scoped write tools (`write_to_file`, `write_file`), and subagent coordination tools (`invoke_subagent`, `send_message`), while keeping `run_command` strictly excluded.
