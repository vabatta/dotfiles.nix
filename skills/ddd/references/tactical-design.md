# Tactical Design Reference

> Sources: Eric Evans — "Domain-Driven Design" (2003) chapters 5–7, Vaughn Vernon —
> "Implementing Domain-Driven Design" (2013) chapters 5–12, Vaughn Vernon — "Effective
> Aggregate Design" (DDD Community, 2011), Microsoft — "Tactical DDD for Microservices"
> (Azure Architecture Center), Scott Millett — "Functional Domain Modeling" (2015)

## Table of Contents

1. [Entities](#entities)
2. [Value Objects](#value-objects)
3. [Aggregates](#aggregates)
4. [Domain Events](#domain-events)
5. [Event Versioning and Schema Evolution](#event-versioning-and-schema-evolution)
6. [Repositories](#repositories)
7. [Domain Services](#domain-services)
8. [Application Services](#application-services)
9. [Factories](#factories)
10. [Modules](#modules)
11. [Specifications](#specifications)
12. [Read Models and Projections](#read-models-and-projections)
13. [Testing Strategies for Domain Models](#testing-strategies-for-domain-models)
14. [Decision Guide: Where Does This Logic Belong?](#decision-guide)

---

## Entities

An entity is an object defined primarily by its **identity** rather than its attributes.
Two entities with identical attributes but different identities are different things.
An entity's identity persists across time and state changes.

### When to Use

Use an entity when the business needs to track an object over time, distinguish it from
others with the same attributes, and observe its lifecycle (creation, state changes,
eventual archival or deletion).

### Design Rules

- Every entity has a unique identifier meaningful to the business or generated as a
  surrogate.
- Entities encapsulate behavior, not just data. An entity should enforce its own
  business rules.
- An entity's identity never changes. Its state changes through well-defined operations.

```
Entity: Order
  Identity: OrderId
  Behavior: place(), addItem(), cancel(), markAsShipped()
  State: items, status, placedAt
  Invariant: A cancelled order cannot be shipped
```

```
Entity: Patient
  Identity: PatientId (e.g., national health number)
  Behavior: admit(), discharge(), recordDiagnosis()
  State: name, dateOfBirth, admissions, diagnoses
  Invariant: A discharged patient cannot receive new diagnoses
```

### Anemic Entity Anti-Pattern

An entity with only getters/setters and no business methods is anemic. Business logic
that operates on the entity's data should live inside the entity, not in an external
service. If you find a service that reads an entity's fields, makes a decision, and
writes back, that logic belongs on the entity.

---

## Value Objects

A value object is defined entirely by its **attributes**. It has no identity. Two value
objects with the same attributes are equal and interchangeable. Value objects should be
**immutable** — once created, they never change. To "change" a value object, create a
new one.

### When to Use

Use a value object for concepts where identity does not matter — where you care about
*what* something is, not *which* one it is.

### Design Rules

- Immutable. No setters, no mutation methods.
- Equality is based on attribute comparison, not reference or identity.
- Value objects can contain validation logic. A `Money(amount, currency)` value object
  can reject negative amounts.
- Prefer value objects over primitives for domain concepts. `EmailAddress` instead of
  `String`, `Money` instead of `BigDecimal`, `DateRange` instead of two `Date` fields.

```
Value Object: Money
  Attributes: amount (decimal), currency (CurrencyCode)
  Behavior: add(Money), subtract(Money)
  Constraint: Both operands must share the same currency
```

```
Value Object: Address
  Attributes: street, city, postalCode, country
  Equality: two addresses are equal if all fields match
```

### Entity vs Value Object Decision

| Question | Entity | Value Object |
|----------|--------|--------------|
| Does the business track this over time? | Yes | No |
| Do two instances with same data need to be distinguished? | Yes | No |
| Does it have a lifecycle (created, modified, archived)? | Yes | No |
| Is it naturally immutable? | No | Yes |
| Is identity irrelevant — only attributes matter? | No | Yes |

---

## Aggregates

An aggregate is a cluster of entities and value objects treated as a single unit for
data changes. It has a **root entity** (the aggregate root) that serves as the sole
entry point for external access. All modifications to the aggregate pass through the
root.

### Vaughn Vernon's Four Aggregate Design Rules

These rules, from Vernon's "Implementing Domain-Driven Design" and "Effective Aggregate
Design" papers, are the foundation of sound aggregate design.

**Rule 1: Model True Invariants in Consistency Boundaries**

An invariant is a business rule that must always be consistent. The aggregate boundary
is a consistency boundary — everything inside it is guaranteed to be consistent after
each transaction. Only group objects that share a true invariant into the same aggregate.

If a rule does not actually require transactional consistency (e.g., "the total value
of all orders for a customer must not exceed $10,000"), consider enforcing it through
eventual consistency instead of cramming everything into one aggregate.

**Rule 2: Design Small Aggregates**

Limit the aggregate to the root entity plus the minimum number of entities and value
objects required to enforce the invariants. Approximately 70% of aggregates can be
designed with just the root entity and value objects — no child entities.

Large aggregates cause:
- Transaction contention (multiple users modifying the same aggregate)
- Performance problems (loading a large object graph)
- Scalability limits (the aggregate is a serialization bottleneck)

**Rule 3: Reference Other Aggregates by Identity Only**

An aggregate should not hold a direct object reference to another aggregate. Instead,
store the other aggregate's identity (its ID). This prevents navigating from one
aggregate deep into another, which would violate aggregate boundaries and create
implicit coupling.

```
WRONG:  Order contains a Customer object
RIGHT:  Order contains a CustomerId
```

**Rule 4: Use Eventual Consistency Outside the Boundary**

When a change in one aggregate must eventually cause a change in another, use domain
events and eventual consistency. Do not modify multiple aggregates in a single
transaction (with rare exceptions — see below).

### When to Break the Rules

Vernon acknowledges situations where breaking the rules is pragmatic:

- **User interface convenience:** A batch operation creates multiple aggregates in one
  transaction for usability reasons.
- **Lack of messaging infrastructure:** If you have no event bus, you may need to
  modify two aggregates in one transaction as a temporary measure.
- **Global invariants with low contention:** If a cross-aggregate invariant is rarely
  violated and the aggregates are not contended, a single transaction may be simpler.

Break the rules consciously, document why, and plan to migrate toward the rules when
feasible.

### Aggregate Root Responsibilities

The root entity:
- Is the only entity accessible from outside the aggregate
- Manages the lifecycle of all objects inside the aggregate
- Enforces all aggregate invariants
- Produces domain events when state changes

External code interacts with the aggregate exclusively through the root's public
methods. Internal entities and value objects are implementation details.

```
Aggregate: Order (root)
  ├── OrderItem (entity, internal)
  │     └── UnitPrice (value object)
  ├── ShippingAddress (value object)
  └── OrderStatus (value object)

  Invariant: An order must have at least one item
  Invariant: Total order value must not exceed the customer's credit limit
  Command: addItem(productId, quantity, unitPrice)
  Command: removeItem(orderItemId)
  Command: submit()
  Event: OrderPlaced
  Event: OrderItemAdded
```

---

## Domain Events

A domain event represents something that happened in the domain that domain experts
care about. Events are named in the **past tense** because they describe facts — things
that have already occurred and cannot be undone.

### When to Use

- To communicate state changes across aggregate boundaries within a bounded context
- To communicate state changes across bounded context boundaries
- To trigger side effects (send an email, update a read model, start a process)
- To build an audit trail of domain-significant occurrences

### Design Rules

- Name events in past tense: `OrderPlaced`, `PaymentReceived`, `ShipmentDispatched`
- Include the data the consumer needs. The consumer should not need to call back to
  the producer to understand the event.
- Events are immutable facts. Once published, they cannot be changed or retracted.
- Events should carry business meaning. `OrderUpdated` is not a domain event — it is
  a CRUD notification. What specifically changed? `ShippingAddressChanged`,
  `OrderCancelled`, `ItemQuantityAdjusted` — these are domain events.

```
Event: OrderPlaced
  Data: orderId, customerId, items[], totalAmount, placedAt
  Triggered by: Order.submit()
  Consumed by: Fulfillment context, Notification service
```

### Events vs Commands

| Aspect | Command | Event |
|--------|---------|-------|
| Tense | Imperative ("Place Order") | Past tense ("Order Placed") |
| Intent | Request that may be rejected | Fact that has occurred |
| Cardinality | One sender, one receiver | One publisher, many subscribers |
| Failure | The handler can refuse | Already happened — cannot be undone |

---

## Event Versioning and Schema Evolution

Domain events outlive the code that produced them. An event published months ago may
be replayed today by a consumer running a newer codebase, or re-read from an event
store after a schema has moved on. Schema evolution rules keep older events readable
without breaking either side of the contract.

### Core Principles

- **Events are immutable instances.** Once published, the payload is a historical fact.
  Schema evolution applies to the event type, not to past instances.
- **Add, do not remove or rename.** Adding optional fields is safe. Removing or
  renaming fields breaks existing consumers and existing event streams.
- **Default missing fields.** Consumers should treat absent fields in older events as
  having a documented default, defined alongside the schema.
- **Version explicitly.** Either include a schema version field on every event, or
  encode the version in the event type name. Implicit versioning hides breakage until
  runtime.

### Compatibility Modes

- **Backward compatible:** New consumers can read old events. Achieved by adding only
  optional fields and providing defaults for absent values.
- **Forward compatible:** Old consumers can read new events. Achieved by ignoring
  unknown fields rather than rejecting them.
- **Full compatibility:** Both directions. Required when producers and consumers
  deploy independently and may run mixed versions at the same time.

### Strategies for Unavoidable Breaking Changes

- **Upcasting** — Translate an old event into the new shape at read time. Keeps the
  domain layer free of legacy concerns; the translation lives at the boundary.
- **New event type** — Publish under a new name; consumers migrate over time; the old
  type is retired once the stream is drained or fully upcasted.
- **Stream rebuild** — Replay the entire event stream into a new, clean stream under
  the new schema. Possible only when the source data and rebuild logic are preserved.

### Supporting Practices

- A schema registry holds the authoritative definition of each event type and version,
  and enforces compatibility rules at publish time.
- Contract tests between producer and consumer detect incompatible changes before
  deployment.
- Documentation alongside each event type captures meaning, ownership, version
  history, and consumer expectations.

---

## Repositories

A repository provides a collection-like interface for accessing aggregates. It
abstracts the persistence mechanism so that the domain model does not depend on
databases, ORMs, or storage technology.

### Design Rules

- One repository per aggregate type. Never per entity or value object.
- The repository interface is defined in the domain layer. The implementation lives
  in the infrastructure layer.
- Repositories retrieve and persist whole aggregates, not fragments.
- The interface uses domain language, not SQL or storage language.

```
Repository: OrderRepository
  Methods:
    findById(orderId): Order
    save(order): void
    nextIdentity(): OrderId
```

Repositories are not generic query engines. Complex queries and reporting belong in
read models or query services, not in aggregate repositories.

---

## Domain Services

A domain service encapsulates domain logic that does not naturally belong to a single
entity or value object. It represents a domain concept or operation, not an
infrastructure concern.

### When to Use

- An operation involves multiple aggregates
- A domain concept is a process or policy rather than a thing
- The logic does not belong to any single entity

### When NOT to Use

- If the logic operates on one entity's data and makes decisions about that entity
  → put it on the entity
- If the logic is about infrastructure (sending emails, calling external APIs)
  → it is an application service, not a domain service

### Design Rules

- Domain services are stateless. They operate on entities and value objects passed
  to them.
- Named using domain language, reflecting the operation they perform.
- Defined in the domain layer, not the application or infrastructure layer.

```
Domain Service: TransferService
  Operation: transfer(sourceAccountId, targetAccountId, amount)
  Logic: Debits source, credits target, enforces transfer limits
  Why not on Account: The operation spans two aggregates
```

---

## Application Services

An application service orchestrates a use case. It receives input from outside the
domain (HTTP requests, message handlers, scheduled jobs, CLI commands), coordinates
the relevant aggregates and domain services, and returns a result. It does not
contain domain logic itself.

### Distinction from Domain Services

- A **domain service** expresses a domain concept and lives in the domain layer.
  Its vocabulary is the ubiquitous language.
- An **application service** orchestrates a use case and lives in the application
  layer. Its vocabulary is the use case, not the domain.

A useful test: if removing the user-facing application would make the concept
meaningless, it is an application service; if the concept would still matter to
domain experts, it is a domain service.

### Responsibilities

- Begin and commit transactions
- Load aggregates through repositories
- Invoke operations on aggregate roots and domain services
- Publish domain events emitted by aggregates
- Translate between external representations (DTOs, commands) and domain objects
- Handle cross-cutting concerns at the use-case boundary: authorization, input
  validation against use-case constraints, error mapping, logging

### Design Rules

- An application service is thin. Business rules live in entities, value objects,
  aggregates, and domain services — never in the application service.
- An application service operates at the granularity of one use case. Bloating it
  with unrelated operations couples otherwise independent flows.
- An application service does not know how the aggregate works internally. It calls
  the aggregate root's public operations.

### Anti-Patterns

- An application service that contains business rules. Move the rules into the
  relevant entity, value object, or domain service.
- An application service that mutates multiple aggregates in one transaction. Prefer
  eventual consistency through domain events.
- A "god" application service holding many unrelated use cases. Split it.
- An application service that returns domain objects directly to the outside world.
  Translate into a representation appropriate for the caller.

---

## Factories

A factory encapsulates the logic of creating complex aggregates or entities. When
constructing an object requires more than a simple constructor — when it involves
validation, assembling multiple parts, or choosing between different representations
— use a factory.

### When to Use

- Object creation is complex (many dependencies, conditional logic)
- The creation logic would clutter the entity's constructor
- You need to create different types based on input

### Design Rules

- Factories produce valid objects. The caller should never receive a half-constructed
  aggregate.
- Factories can be standalone classes, static methods on the aggregate root, or methods
  on a repository (for reconstitution from persistence).

```
Factory: OrderFactory
  Method: createOrder(customerId, items[], shippingAddress)
  Logic: Validates customer exists, validates items are available,
         calculates totals, returns a fully valid Order aggregate
```

---

## Modules

Modules (packages, namespaces) organize the domain model into cohesive units. They
are the first level of structural organization within a bounded context.

### Design Rules

- Modules should reflect the ubiquitous language, not technical layers.
- Group by domain concept, not by pattern type. `com.example.orders` (domain concept)
  not `com.example.entities` (pattern type).
- Modules have low coupling between them and high cohesion within.

```
WRONG (organized by pattern):
  entities/
  value_objects/
  repositories/
  services/

RIGHT (organized by domain concept):
  ordering/
  fulfillment/
  pricing/
  customer/
```

---

## Specifications

A specification encapsulates a business rule as a predicate — an object that answers
"does this thing satisfy this criterion?" Specifications can be combined with boolean
logic (and, or, not) to build complex selection or validation criteria.

### When to Use

- Selection: "Find all orders that are overdue and above $500"
- Validation: "Does this applicant meet the eligibility criteria?"
- Construction: "Build an object that satisfies these constraints"

```
Specification: OverdueOrderSpecification
  Predicate: order.dueDate < today AND order.status != Completed
  Usage: orderRepository.findAll(overdueOrderSpec)
```

---

## Read Models and Projections

The aggregate model is shaped for command processing — enforcing invariants, protecting
consistency. It is rarely well-shaped for queries, especially complex reporting or
cross-aggregate views. A read model is a separate representation of data optimized for
a specific query need. A projection is the process that builds and maintains a read
model, typically by subscribing to domain events and updating denormalized state.

### Properties of Read Models

- **Denormalized** — joins are precomputed; shape mirrors the query, not the writes
- **Query-optimized** — structured to match the screens, reports, or APIs that consume
  it
- **Eventually consistent** — lags behind the write model; consumers must tolerate
  staleness
- **Disposable** — can be rebuilt from the source data or event stream at any time;
  not a system of record

### When to Use

- Queries span multiple aggregates and the joins are expensive or awkward
- Reporting needs differ substantially from operational data shapes
- High-read, low-write workloads benefit from caching at the model level
- Different consumers need different views of the same underlying facts

### Relationship to CQRS and Event Sourcing

Read models are the read side of a command/query split. They do not require full
event sourcing — projections built from domain events are valuable even when the
write model uses traditional state-based storage. Adopting read models is a
lightweight step on a spectrum that includes, but does not require, full CQRS and
event sourcing.

### Design Rules

- One read model per query need. Resist the urge to build a single "universal" read
  model — it drifts toward a shared data model and re-creates the coupling read
  models exist to avoid.
- Projections are idempotent. Replaying the same events must produce the same read
  model.
- The aggregate is the source of truth. The read model is a derivative; if the two
  disagree, the aggregate wins and the projection is replayed.
- Read models live outside the domain layer. The domain emits events; an
  infrastructure or application component maintains the projection.

### Anti-Patterns

- Reading through aggregate repositories for complex multi-aggregate queries. Build a
  read model instead.
- Writing to a read model directly from a use case, bypassing the projection. This
  decouples the read model from the events that should drive it.
- Treating the read model as authoritative. Source-of-truth status belongs to the
  aggregate or the event stream.
- Coupling read models to each other. Each projection should consume events
  independently.

---

## Testing Strategies for Domain Models

The domain model is the most testable part of a DDD system because it has no
infrastructure dependencies. Tests should exercise business rules through the public
surface of aggregates, value objects, and domain services.

### Levels of Test

**Aggregate unit tests** — Construct the aggregate, issue commands on the root,
assert the resulting state and emitted events. Tests are framed as Given/When/Then
against the aggregate's own API. Repositories, databases, and external services are
not involved.

**Value object tests** — Verify equality semantics, validation rules at construction,
and the immutability of derived values.

**Domain service tests** — Provide the aggregates and value objects the service
operates on, invoke the operation, assert the result. Use in-memory implementations
of any required collaborators in preference to mocks.

**Specification tests** — Verify the predicate evaluates correctly across
representative inputs. Composed specifications are tested by composition, not by
re-testing the operands.

**Application service tests** — Exercise the use case end-to-end through the
application service, with infrastructure substituted by in-memory equivalents.
Verify orchestration, transaction boundaries, and event publication.

**Integration tests** — Verify that repository implementations correctly reconstitute
aggregates, that projections build the expected read models, and that domain events
flow to their real consumers.

### Guidelines

- Use the ubiquitous language in test names. A test name should read like a sentence
  in the domain.
- Test invariants explicitly. For every invariant on every aggregate, there should be
  at least one test that proves the invariant cannot be violated through the
  aggregate's public surface.
- Verify events as first-class outputs. Asserting state alone misses the message the
  aggregate emits to the rest of the system.
- Treat tests as living documentation. A future reader should be able to learn how
  the domain behaves by reading them.

### Anti-Patterns

- Testing private methods or internal helpers. The aggregate's public surface is what
  matters; refactoring internals should not break tests.
- Mocking value objects or entities. They have no infrastructure dependencies; use
  them directly.
- Testing the framework (ORM mappings, serialization, HTTP plumbing) inside domain
  unit tests. Those belong in integration tests.
- Heavy use of mocks in domain tests. The need for mocks usually signals that
  infrastructure has leaked into the domain layer.
- Asserting only the final state when the contract is "this command must emit this
  event." Tests should mirror the actual public contract.

---

## Decision Guide

**"Where does this logic belong?"**

| Situation | Put it in |
|-----------|-----------|
| Logic about one entity's own state | The entity |
| Logic combining an entity's data with its value objects | The entity |
| Logic spanning multiple aggregates in the same context | A domain service |
| Logic for creating a complex aggregate | A factory |
| Logic for retrieving/storing an aggregate | A repository |
| Logic that is a named business predicate | A specification |
| A concept with identity and lifecycle | An entity |
| A concept without identity, defined by attributes | A value object |
| A cluster protecting transactional invariants | An aggregate |
| Something that happened in the domain | A domain event |
| Infrastructure concerns (email, HTTP, DB) | Application or infrastructure service |
