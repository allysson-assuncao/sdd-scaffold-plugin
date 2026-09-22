---
name: stack-contract
description: >-
  Use this skill to understand the interface contract that any stack-specific
  skill must implement to be compatible with the sdd-scaffold-plugin. It provides
  the blank template, required metadata hooks, and validation checklist for creating
  a new stack plug-in (e.g., spring-boot-stack, nextjs-stack, fastapi-stack).
  Activate when building, evaluating, or auditing a technology-specific skill
  for use with the SDD lifecycle.
---

# Skill: `stack-contract` — Stack Plug-in Interface

This skill defines the **interface contract** that any technology-specific (stack) skill must satisfy to integrate seamlessly with the `sdd-scaffold-plugin` lifecycle — specifically with the `tdd-enforcer`, `security-auditor`, and `test-runner` subagents.

---

## When to Activate

Activate this skill when:
- Building a new stack skill (e.g., `spring-boot-stack`, `nextjs-stack`, `fastapi-stack`).
- Evaluating whether an existing external skill is compatible with SDD.
- Debugging why a stack skill isn't being picked up by `test-runner` or `security-auditor`.

---

## The Three Required Hooks

Every compatible stack skill MUST declare these three hooks in its `SKILL.md` frontmatter:

```yaml
---
name: <stack-name>-stack
description: >-
  [Third-person description of when to use this skill]
# --- SDD Stack Contract ---
sdd_stack_contract:
  test_command: "<exact shell command to run the test suite>"
  lint_command: "<exact shell command to run linting/static analysis>"
  setup_command: "<exact shell command to install dependencies and bootstrap the project>"
---
```

### `test_command`

The exact command the `test-runner` subagent will execute to run the project's test suite.

**Examples:**
```yaml
test_command: "npm test"
test_command: "mvn test -q"
test_command: "pytest --tb=short -q"
test_command: "go test ./... -v"
test_command: "dotnet test --no-build --verbosity minimal"
```

### `lint_command`

The exact command the `security-auditor` subagent will execute for static analysis and linting.

**Examples:**
```yaml
lint_command: "npm run lint && npx eslint . --max-warnings 0"
lint_command: "mvn checkstyle:check spotbugs:check"
lint_command: "ruff check . && bandit -r src/"
lint_command: "golangci-lint run"
```

### `setup_command`

The command `sdd-init` will suggest when bootstrapping a project with this stack.

**Examples:**
```yaml
setup_command: "npm install"
setup_command: "mvn install -DskipTests"
setup_command: "pip install -r requirements.txt"
setup_command: "go mod download"
```

---

## Naming Convention

Stack skills MUST follow this naming pattern:

| Convention | Example |
|---|---|
| `<technology>-stack` | `spring-boot-stack` |
| `<framework>-stack` | `nextjs-stack` |
| `<language>-<framework>-stack` | `python-fastapi-stack` |

The skill directory must be named exactly as the `name` field in frontmatter.

---

## Compatibility Validation Checklist

Before publishing a stack skill as SDD-compatible, verify:

- [ ] `SKILL.md` frontmatter contains `name`, `description`, and `sdd_stack_contract` block
- [ ] `test_command` runs the full test suite and exits with code `0` on success, non-zero on failure
- [ ] `lint_command` exits with code `0` only when no lint violations are present
- [ ] `description` is written in third person and specifies when the skill should be activated
- [ ] The skill does NOT define SDD governance rules (those belong to this plugin's `rules/` layer)
- [ ] The skill does NOT override approval gate behavior
- [ ] Examples are included in `examples/` directory (at least one passing and one failing test pattern)

---

## Plug-in Registration

To use a stack skill alongside this plugin, declare both in the project's `.agents/plugins.json`:

```json
{
  "entries": [
    {
      "path": "~/.gemini/config/plugins/sdd-scaffold-plugin",
      "_comment": "SDD governance — rules, skills, subagents"
    },
    {
      "path": "~/.gemini/config/plugins/spring-boot-stack",
      "_comment": "Stack-specific implementation patterns"
    }
  ]
}
```

---

## Template

The blank stack skill template is in `resources/stack-skill-template/SKILL.md.tmpl`. Copy it to get started.

