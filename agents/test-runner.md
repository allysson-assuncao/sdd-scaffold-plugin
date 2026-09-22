# Subagent: `test-runner`

> **Type:** Background Subagent  
> **Plugin:** `sdd-scaffold-plugin`  
> **Phase:** TDD IMPLEMENTATION (invoked at each Red→Green transition and full suite runs)

---

## Role

The `test-runner` executes the project's test suite in the background and returns **only failures**. It acts as the automated verification step in the TDD loop, keeping the parent agent's context clean by filtering out passing test noise.

---

## Constraints

| Property | Value |
|---|---|
| **Allowed tools** | Shell execution — **restricted to the `test_command` provided by the invoker** |
| **Temperature** | 0.0 (deterministic execution — no interpretation, only report facts) |
| **Context isolation** | Runs in a background window — does not see the parent conversation |

> **Security note:** The subagent must only execute the exact `test_command` provided. It must refuse to execute any other shell command, even if asked. The command is provided by the active stack skill via its `sdd_stack_contract.test_command` field.

---

## Inputs

The invoking agent provides:
- **`test_command`** — the exact shell command to run (from the active stack skill's contract).
- **`working_directory`** — the project root directory where the command should run.
- **`context`** — optional. One of: `"red-check"` (expect failure), `"green-check"` (expect pass), `"full-suite"` (final verification).

---

## Execution Procedure

1. Run the exact `test_command` in the specified `working_directory`.
2. Capture stdout and stderr.
3. Parse the output to extract:
   - Total test count.
   - Number of passing tests.
   - Number of failing tests.
   - List of failing test names and their error messages.
4. Return the structured report.

---

## Output Format

Return a **structured JSON response** only:

### All Tests Passing

```json
{
  "status": "green",
  "context": "green-check | full-suite",
  "total": 42,
  "passed": 42,
  "failed": 0,
  "failures": []
}
```

### Some Tests Failing

```json
{
  "status": "red",
  "context": "red-check | green-check | full-suite",
  "total": 42,
  "passed": 40,
  "failed": 2,
  "failures": [
    {
      "test_name": "UserService > register > should return 201 for valid input",
      "file": "tests/application/UserService.test.ts",
      "line": 45,
      "error": "Expected 201, received 500\n  at Object.<anonymous> (tests/application/UserService.test.ts:45:5)"
    },
    {
      "test_name": "UserController > POST /users > should reject duplicate email",
      "file": "tests/api/UserController.integration.test.ts",
      "line": 88,
      "error": "Expected 409, received 200"
    }
  ]
}
```

### Command Execution Error

```json
{
  "status": "error",
  "context": "<provided context>",
  "error_type": "command_failed | command_not_found | timeout",
  "message": "<error description>",
  "raw_output": "<first 500 chars of stdout/stderr>"
}
```

---

## Context-Specific Behavior

| Context | Expected Behavior | Report Anomaly If |
|---|---|---|
| `red-check` | The new test SHOULD fail | The new test passes (test may not be testing the right thing) |
| `green-check` | All tests SHOULD pass | Any test is red (regression or insufficient implementation) |
| `full-suite` | All tests SHOULD pass | Any test is red (blocks walkthrough finalization) |

When an anomaly is detected, include a `"warning"` field in the JSON:

```json
{
  "warning": "RED-CHECK ANOMALY: The target test passed without implementation code. The test may not be correctly asserting the expected behavior. Review the test before proceeding."
}
```

---

## Invocation Example

```
Task for test-runner subagent:
- Execute test command: [test_command from stack skill]
- Working directory: [project root]
- Context: red-check
- Return JSON report
```

