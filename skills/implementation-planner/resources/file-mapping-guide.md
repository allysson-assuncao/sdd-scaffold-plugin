# File Mapping Guide — `[NEW]`, `[MODIFY]`, `[DELETE]` Conventions

This guide defines the naming conventions, architectural layer definitions, and file mapping syntax used in `implementation_plan.md` artifacts.

---

## The Three Markers

| Marker | When to Use |
|---|---|
| `[NEW]` | A file that does not exist and will be created from scratch |
| `[MODIFY]` | A file that already exists and will have its content changed |
| `[DELETE]` | A file that currently exists and will be removed entirely |

Every file entry in an implementation plan MUST be prefixed with one of these markers. No unmarked files.

---

## Architectural Layer Reference

Group files from innermost (most stable, least framework-dependent) to outermost (most infrastructure-dependent):

### Layer 1: Domain / Core

> The heart of the application. Contains business entities, value objects, domain services, and domain events. **Zero framework dependencies** — this layer must be runnable with no infrastructure.

**Naming patterns:**
- `src/domain/entities/` — core business objects
- `src/domain/value-objects/` — immutable, equality-by-value objects
- `src/domain/services/` — domain logic that doesn't belong to a single entity
- `src/domain/events/` — domain events for decoupled communication
- `src/domain/repositories/` — repository *interfaces* (not implementations)

### Layer 2: Application / Use Cases

> Orchestrates domain objects to fulfill use cases. Contains application services, command/query handlers (CQRS), and DTOs. **May depend on domain layer only.**

**Naming patterns:**
- `src/application/use-cases/` — one class/function per use case
- `src/application/commands/` — write-side DTOs (CQRS)
- `src/application/queries/` — read-side DTOs (CQRS)
- `src/application/services/` — application-level orchestration services

### Layer 3: Infrastructure / Persistence

> Concrete implementations of domain repository interfaces. Contains database adapters, ORM models, external API clients, cache providers, file storage adapters. **May depend on application and domain layers.**

**Naming patterns:**
- `src/infrastructure/persistence/` — database repository implementations
- `src/infrastructure/adapters/` — adapters for external services
- `src/infrastructure/migrations/` — database schema migrations
- `src/infrastructure/config/` — infrastructure configuration

### Layer 4: API / Interface Layer

> Entry points into the application. HTTP controllers, GraphQL resolvers, CLI commands, event consumers, message queue handlers. **May depend on application layer only (not domain directly).**

**Naming patterns:**
- `src/api/controllers/` — HTTP controllers / route handlers
- `src/api/middleware/` — request/response middleware
- `src/api/schemas/` — request/response validation schemas
- `src/api/graphql/` — GraphQL resolvers and type definitions

### Layer 5: Tests

Mirror the source layer structure under the test root:

```
tests/
├── domain/        → mirrors src/domain/
├── application/   → mirrors src/application/
├── infrastructure/→ mirrors src/infrastructure/
└── api/           → mirrors src/api/ (integration tests)
```

**Test file naming:**
- Unit tests: `[FileName].test.ts` or `test_[file_name].py`
- Integration tests: `[FileName].integration.test.ts`
- End-to-end tests: `[scenario-name].e2e.test.ts`

---

## Example Implementation Plan File Mapping

```markdown
### Layer: Domain / Core

#### [NEW] `src/domain/entities/User.ts`
Defines the `User` entity with identity, email, and hashed-password value object.

#### [NEW] `src/domain/repositories/IUserRepository.ts`
Interface contract for user persistence. No implementation details.

### Layer: Application / Use Cases

#### [NEW] `src/application/use-cases/RegisterUser.ts`
Orchestrates the user registration flow: validates uniqueness, hashes password, persists via IUserRepository.

### Layer: Infrastructure / Persistence

#### [NEW] `src/infrastructure/persistence/PostgresUserRepository.ts`
Implements `IUserRepository` using PostgreSQL + TypeORM.

#### [NEW] `src/infrastructure/migrations/001_create_users_table.ts`
Creates the `users` table with `id`, `email`, `password_hash`, `created_at` columns.

### Layer: API / Interface

#### [NEW] `src/api/controllers/UserController.ts`
Exposes `POST /api/v1/users` endpoint. Validates request, delegates to `RegisterUser` use case.

### Layer: Tests

#### [NEW] `tests/domain/entities/User.test.ts`
Unit tests for the `User` entity's business rules.

#### [NEW] `tests/application/use-cases/RegisterUser.test.ts`
Unit tests for the `RegisterUser` use case with mocked `IUserRepository`.

#### [NEW] `tests/api/UserController.integration.test.ts`
Integration test for `POST /api/v1/users` against a test database.
```

---

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|---|---|---|
| Skipping the Domain layer | Makes the application untestable without infrastructure | Always model domain first |
| Putting business logic in controllers | Controllers become fat, untestable, hard to maintain | Move logic to use cases / domain services |
| Infrastructure interfaces in the Domain layer | Creates coupling to a specific database or framework | Define interfaces in Domain, implement in Infrastructure |
| Omitting `[NEW]/[MODIFY]/[DELETE]` markers | Makes the plan ambiguous — is this file new or existing? | Always mark every file |
| Listing test files without corresponding source files | Makes the plan incomplete | Every source file should have a corresponding test file entry |

