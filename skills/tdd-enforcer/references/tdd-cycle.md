# TDD Cycle Reference — Red-Green-Refactor Patterns

This reference covers the core Red-Green-Refactor (RGR) patterns, common failure modes, and anti-patterns that the `tdd-enforcer` skill enforces.

---

## The Three Phases

```
RED  →  GREEN  →  REFACTOR  →  [next task]  →  RED  →  ...
```

| Phase | Goal | Rule |
|---|---|---|
| **RED** | Write a failing test | The test must fail for the RIGHT reason |
| **GREEN** | Make the test pass | Write the MINIMUM code — no more |
| **REFACTOR** | Improve the code | All tests must stay green throughout |

---

## RED Phase: Writing Good Tests

### The Test Must Fail for the Right Reason

A test that fails with `ImportError` or `ClassNotFoundException` is failing for the wrong reason — the module/class doesn't exist yet. This is acceptable as a first step, but the test must be structured so that once the class exists, it will fail with an **assertion error** that matches the expected behavior.

**Wrong failure (acceptable temporarily):**
```
ImportError: cannot import name 'UserService' from 'app.services'
```

**Right failure (what you must reach before going Green):**
```
AssertionError: Expected HTTP 201, got HTTP 500
```

### Triangulation

If the minimum code to pass one test is to hardcode the return value, write a second test with a different input that forces a real implementation.

```python
# Test 1: agent might hardcode "alice@example.com" to pass this
def test_register_user_returns_email():
    result = register_user("alice@example.com", "pass")
    assert result["email"] == "alice@example.com"

# Test 2: now hardcoding won't work for both — real logic required
def test_register_different_user():
    result = register_user("bob@example.com", "pass")
    assert result["email"] == "bob@example.com"
```

---

## GREEN Phase: Minimum Code Rules

| Allowed | Not Allowed |
|---|---|
| Hardcoded return values (temporarily) | Logic not exercised by any test |
| `if/else` branching by test input | Optimizations (caching, indexing) |
| In-memory data stores | External service calls not tested |
| Copy-paste duplication | Future-proofing or speculative design |

**The Fake It 'Til You Make It pattern is valid:**

```python
# Green: hardcoded — this passes the test cheaply
def get_user_status(user_id):
    return "active"  # TODO: triangulate with a second test
```

---

## REFACTOR Phase: Refactoring Safely

### Refactor In Small Steps

Never refactor more than one thing at a time. Run tests after each micro-step:

```
Step 1: Rename variable        → run tests → green ✅
Step 2: Extract method         → run tests → green ✅
Step 3: Remove duplication     → run tests → green ✅
```

### What Counts as Refactoring

✅ Refactoring (no behavior change):
- Renaming variables, methods, classes
- Extracting methods or helper functions
- Reorganizing code into appropriate layers
- Adding inline documentation

❌ Not refactoring (behavior change — requires a new test first):
- Adding a new feature
- Changing a method signature
- Adding a new parameter
- Changing error handling behavior

---

## Common TDD Anti-Patterns

### 1. Testing After the Fact

Writing tests after production code defeats the purpose. Tests written after code tend to confirm the implementation rather than specify behavior.

**Fix:** If caught writing production code before a test, delete the production code, write the test first, then re-implement.

### 2. Test Interdependence

Tests must be **independent and isolated**. Each test should set up its own state and tear it down.

**Fix:** Use setup/teardown fixtures. Mock external dependencies. Never share mutable state between tests.

### 3. Testing Implementation Instead of Behavior

Testing which internal method gets called instead of what the observable outcome is.

❌ Implementation test:
```python
assert mock_repository.save.called_once()  # How it works
```

✅ Behavior test:
```python
response = client.post("/users", json={"email": "a@b.com"})
assert response.status_code == 201  # What it does
```

### 4. Giant Tests

A single test that tests multiple behaviors at once. When it fails, you don't know why.

**Fix:** One assertion per test (or one concept per test). Use descriptive test names that complete the sentence: _"it should..."_

### 5. Skipping the Refactor Phase

Going directly from Green to the next Red without cleaning up. This accumulates technical debt that compounds across the sprint.

**Fix:** Always allocate time for refactoring before marking a task `[x]`.

---

## Test Quality Checklist

Before marking a Red task complete and moving to Green, verify:

- [ ] The test fails with an assertion error (not a syntax or import error)
- [ ] The test name clearly describes the behavior being tested
- [ ] The test is isolated (no shared state with other tests)
- [ ] The test references the acceptance criterion it covers (as a comment if needed)
- [ ] The test would catch a regression if the behavior changed

