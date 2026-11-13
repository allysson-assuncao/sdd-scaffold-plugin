# Delta Spec: `agent-sdd-prompt-architect`

> **Change ID:** `fix-subagent-tool-conflicts-and-resource-paths`
> **Target Canonical Spec:** `openspec/specs/agent-sdd-prompt-architect.md`
> **Change Type:** Modify

## Architectural Updates

### Frontmatter Contract
Update Section 2 `tools:` sequence to remove `view_file` and `write_to_file`:

```yaml
tools:
  - read_file
  - grep_search
  - find_by_name
  - list_dir
  - write_file
  - invoke_subagent
  - send_message
```

### Operational Requirements
Update Section 3 to clarify:
- **Tooling Restrictions:** Read tools (`read_file`, `grep_search`, `find_by_name`, `list_dir`), scoped write tools (`write_file`), and subagent coordination tools (`invoke_subagent`, `send_message`). Legacy aliases (`view_file`, `write_to_file`) are strictly omitted to prevent duplicate tool resolution conflicts in the Antigravity runtime.
