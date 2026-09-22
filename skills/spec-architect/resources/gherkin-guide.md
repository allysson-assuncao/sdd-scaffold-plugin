# Gherkin Writing Guide — Acceptance Criteria Standards

This guide defines the quality standards for writing **Given-When-Then** acceptance criteria in SDD `spec.md` artifacts. It is the reference used by the `spec-architect` skill and the `spec-reviewer` subagent.

---

## The Structure

```gherkin
Given [a precondition — the state of the world before the action]
When  [an action — what an actor or system does]
Then  [an outcome — what must be observable after the action]
And   [additional assertion — chained to Then, optional]
```

---

## Quality Rules

### Rule 1: One Action Per Scenario

Each `When` clause must contain **exactly one action**. If you find yourself writing "When the user does X and Y", split it into two scenarios.

❌ Bad:
```
When the user submits the form and clicks confirm
```

✅ Good:
```
When the user submits the form
Then a confirmation dialog appears

When the user clicks confirm on the dialog
Then the form is processed
```

---

### Rule 2: Concrete and Quantifiable "Then" Clauses

Every `Then` must be **testable** — it must specify an observable, measurable outcome. Avoid vague assertions.

❌ Bad:
```
Then the system should handle the error appropriately
```

✅ Good:
```
Then the system returns HTTP 400 Bad Request
And the response body contains: { "error": "INVALID_EMAIL", "message": "The email field is required." }
```

---

### Rule 3: No Implementation Details in "Given" or "When"

Scenarios describe **behavior**, not implementation. Avoid referencing internal classes, database tables, or method names.

❌ Bad:
```
When the UserRepository.save() method is called
```

✅ Good:
```
When the user submits a valid registration form
```

---

### Rule 4: Avoid Ambiguous Qualifiers

Words like "appropriate", "correctly", "properly", "quickly", and "efficiently" are not testable. Always replace them with concrete criteria.

| Ambiguous | Concrete |
|---|---|
| "responds quickly" | "responds within 200ms at the 95th percentile" |
| "handles errors correctly" | "returns HTTP 422 with error code `VALIDATION_FAILED`" |
| "displays a message" | "displays the message: 'Your account has been created.'" |

---

### Rule 5: Cover All Four Scenario Types

Every feature spec MUST cover at minimum:

1. **Happy path** — the primary success scenario.
2. **Validation error** — invalid input by the actor.
3. **Authorization error** — unauthorized actor attempts the action.
4. **Edge/boundary case** — a valid but unusual input (e.g., empty list, maximum values, concurrent requests).

---

## Example: Complete, High-Quality Spec Scenario

```gherkin
### Scenario 1: Successful user registration

- **Given** no account exists with the email "user@example.com"
- **When** the client sends a POST request to `/api/v1/users` with:
  ```json
  { "email": "user@example.com", "password": "Str0ng!Pass" }
  ```
- **Then** the system creates the user account
- **And** returns HTTP 201 Created
- **And** the response body includes:
  ```json
  { "id": "<uuid>", "email": "user@example.com", "createdAt": "<ISO-8601>" }
  ```

### Scenario 2: Duplicate email registration

- **Given** an account already exists with the email "user@example.com"
- **When** the client sends a POST request to `/api/v1/users` with that same email
- **Then** the system returns HTTP 409 Conflict
- **And** the response body contains:
  ```json
  { "error": "EMAIL_ALREADY_EXISTS", "message": "An account with this email already exists." }
  ```

### Scenario 3: Missing required field

- **Given** the client constructs a registration request without the `password` field
- **When** the client sends that POST request to `/api/v1/users`
- **Then** the system returns HTTP 400 Bad Request
- **And** the response body contains:
  ```json
  { "error": "VALIDATION_FAILED", "fields": [{ "field": "password", "message": "Password is required." }] }
  ```
```

---

## `spec-reviewer` Validation Checklist

The `spec-reviewer` subagent validates every spec against this checklist:

- [ ] All scenarios have Given-When-Then structure
- [ ] No `Then` clause contains vague qualifiers ("appropriately", "correctly", etc.)
- [ ] At least one happy path scenario exists
- [ ] At least one error/validation scenario exists
- [ ] YAML front-matter is complete (all required fields present and non-empty)
- [ ] `depends_on` IDs exist in the project's specs directory (or are empty)
- [ ] Open questions section is empty (all questions resolved before Gate 1)
- [ ] Out of scope section is present and non-empty

