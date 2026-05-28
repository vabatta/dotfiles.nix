---
name: ddd
description: >
  Perform all Domain-Driven Design tasks: strategic design (subdomains, bounded contexts,
  context maps, ubiquitous language), tactical design (entities, value objects, aggregates,
  domain events, repositories, domain services, factories), and collaborative modeling
  (Event Storming, bounded context canvas). Use this skill whenever the user mentions
  "DDD", "domain-driven", "bounded context", "aggregate", "value object", "domain event",
  "context map", "subdomain", "core domain", "anti-corruption layer", "event storming",
  "domain model", "aggregate root", or asks to decompose a system, identify service
  boundaries, model a business domain, design aggregates, or map context relationships.
  Also trigger for "how should I split this monolith", "where do I draw the boundaries",
  "model this domain", "help me understand this business domain", or upstream/downstream
  team relationships. Covers all DDD activities from strategic analysis through tactical
  implementation.
---

# Domain-Driven Design

You perform Domain-Driven Design across all its activities — from high-level strategic
analysis down to tactical modeling within a bounded context. Your output is always
grounded in the business domain, never in technology choices.

DDD was introduced by Eric Evans in "Domain-Driven Design: Tackling Complexity in the
Heart of Software" (2003) and later expanded by Vaughn Vernon in "Implementing
Domain-Driven Design" (2013) and Vlad Khononov in "Learning Domain-Driven Design" (2021).
The patterns and practices below synthesize these foundational works with modern community
practices from the DDD Crew, Alberto Brandolini's Event Storming, and Nick Tune's
Bounded Context Canvas.

## Before You Begin

1. Read `references/strategic-design.md` for **subdomain classification, bounded context
   identification, context mapping patterns, and ubiquitous language**.
2. Read `references/tactical-design.md` for **entities, value objects, aggregates,
   domain events, repositories, domain services, and factories**.
3. Apply every rule below on top of those references.

## Core Principles (Non-Negotiable)

### 1. The Domain Is the Center of Everything

DDD exists because business domains are complex. The entire purpose is to build software
that faithfully models the business — not the database, not the API, not the UI. Every
design decision flows from understanding the domain. If you find yourself discussing
tables, endpoints, or frameworks before understanding the business rules, stop and
refocus on the domain.

### 2. Ubiquitous Language Is the Foundation

Every bounded context has its own ubiquitous language — the precise vocabulary that domain
experts and developers share. The same word may mean different things in different contexts,
and that divergence is intentional.

**The language shapes the model and the model shapes the language.** When domain experts
and developers cannot agree on a term, it signals a modeling problem. Resolve it by deeper
domain exploration, not by inventing technical jargon.

```
WRONG: "The UserEntity has a StatusEnum field"
RIGHT: "An Applicant has a ReviewOutcome — approved, rejected, or pending"
```

```
WRONG: "We POST to /orders to create an OrderDTO"
RIGHT: "A Customer places an Order, which the Fulfillment team processes"
```

### 3. Strategic Design Before Tactical Design

Identify subdomains and bounded contexts before modeling aggregates and entities.
Getting the boundaries wrong is far more expensive than getting an entity's fields wrong.
A perfectly designed aggregate in the wrong bounded context creates coupling that undermines
the entire system.

### 4. Boundaries Reflect Organizational Reality

Bounded contexts align with team ownership. A context boundary that cuts across two teams
creates coordination overhead that erodes the model's integrity. Conway's Law applies:
the system's structure will mirror the organization's communication structure. Design
boundaries that work with this reality, not against it.

### 5. Model Only What Matters — Distill the Core

Not every part of the domain deserves the same investment. Core subdomains — the ones
that provide competitive advantage — get deep modeling. Supporting and generic subdomains
get simpler treatment or off-the-shelf solutions. Applying full DDD rigor to a generic
subdomain wastes effort; neglecting the core domain wastes opportunity.

## The DDD Workflow

DDD is not a waterfall process. It is iterative and discovery-driven. However, the
activities follow a general progression:

### Phase 1: Domain Discovery

**Goal:** Understand the business domain before touching code or architecture.

Activities:
- Talk to domain experts. Listen for the language they use naturally.
- Identify the key business processes and the events that matter to stakeholders.
- Run collaborative modeling sessions (Event Storming, Domain Storytelling) to surface
  the domain's structure.
- Capture the ubiquitous language — specific terms, their definitions, and the contexts
  in which they apply.

### Phase 2: Strategic Design

**Goal:** Decompose the domain into subdomains and bounded contexts, then map their
relationships.

Activities:
- Classify subdomains as **core**, **supporting**, or **generic**.
- Identify bounded contexts — each with its own ubiquitous language and model.
- Draw the context map showing relationships between contexts (partnership, customer-
  supplier, conformist, anti-corruption layer, open host service, published language,
  shared kernel, separate ways).
- Assess the organizational and team structure against the proposed boundaries.

Read `references/strategic-design.md` for the complete pattern catalog and decision
guidance.

### Phase 3: Tactical Design

**Goal:** Model the internals of each bounded context using DDD building blocks.

Activities:
- Identify aggregates and their boundaries (protect true invariants).
- Distinguish entities from value objects.
- Define domain events that communicate across aggregate and context boundaries.
- Design repositories as collection-like interfaces for aggregate persistence.
- Extract domain services for logic that does not belong to a single entity or value
  object.
- Use factories for complex object creation.

Read `references/tactical-design.md` for the complete pattern catalog, aggregate design
rules, and decision guidance.

### Phase 4: Continuous Refinement

**Goal:** Evolve the model as domain understanding deepens.

The model is never finished. As the team learns more about the domain, the ubiquitous
language evolves, aggregate boundaries shift, and new contexts emerge. This is expected
and healthy. Resist the urge to freeze the model.

## Collaborative Modeling Techniques

### Event Storming

Created by Alberto Brandolini. A workshop technique that uses colored sticky notes on a
timeline to explore the domain collaboratively.

Three levels of Event Storming exist:

**Big Picture** — Explore the entire business domain at a high level. Identify domain
events, hotspots (pain points), bounded context boundaries, and the key actors.
Participants: everyone — domain experts, developers, product, QA.

**Process Modeling** — Zoom into a single business process. Map the happy path first,
then add alternative flows, error cases, and policies. Participants: 4–8 people focused
on one process.

**Software Design** — Zoom into a single bounded context. Identify aggregates, commands,
events, read models, and policies. Participants: the development team for that context.

The sticky note color scheme:
- **Orange** — Domain Events (past tense: "Order Placed", "Payment Received")
- **Blue** — Commands (imperative: "Place Order", "Ship Package")
- **Yellow** — Actors / Users who issue commands
- **Light Yellow** — Aggregates (the thing that receives the command and produces the event)
- **Purple / Lilac** — Policies / Business Rules ("When X happens, then Y")
- **Pink / Red** — Hotspots / Questions / Problems
- **Green** — Read Models / Information displays

### Domain Storytelling

Created by Stefan Hofer and Henning Schwentner. A guided, narrative modeling technique
in which domain experts tell concrete stories of how the business works, and a moderator
draws them using a small pictographic language: actors, work objects, activities, and
numbered arrows showing sequence. Each story captures one scenario, from one point of
view, at one moment in time.

Core elements:
- **Actor** — the person or system that performs an action
- **Work Object** — the thing the action is performed on
- **Activity** — a verb describing what happens, numbered to convey sequence
- **Annotation** — clarifying notes attached to elements
- **Group** — a visual cluster suggesting a candidate bounded context or subdomain

Strengths relative to Event Storming: Domain Storytelling is more guided and linear.
It works well with stakeholders who find sticky-note chaos overwhelming, and it
produces a sequential, easy-to-read picture of one concrete flow rather than a
panoramic timeline of all events. It is particularly effective for distinguishing
as-is from to-be processes and for surfacing the language each role uses.

When to use: For onboarding into an unfamiliar domain, for resolving disputes about
how a process actually runs today versus how it should run, and for cross-checking
the language uncovered by Event Storming. Each story is a snapshot; multiple stories
together form a map.

### Bounded Context Canvas

Created by Nick Tune (DDD Crew). A structured template for documenting a bounded context's
design. Sections include:

- **Name and Purpose** — business-language description of what the context does and why
- **Strategic Classification** — core / supporting / generic; evolution stage
- **Domain Roles** — the behavioral archetype (execution, analysis, gateway, etc.)
- **Inbound Communication** — commands and queries the context accepts
- **Outbound Communication** — events and responses the context publishes
- **Ubiquitous Language** — key terms and their definitions within this context
- **Business Decisions** — the domain rules the context enforces
- **Assumptions** — what the team believes but has not verified
- **Open Questions** — what remains unknown

Use the canvas after identifying bounded contexts to flesh out their design before
implementation.

## Output Formats

Match the deliverable to the task:

### Subdomain Analysis
```
## Domain: {business domain name}

### Core Subdomains
- **{name}**: {why it's core — competitive advantage, unique logic}

### Supporting Subdomains
- **{name}**: {what it supports, why it's not core}

### Generic Subdomains
- **{name}**: {why it's generic — could be off-the-shelf}
```

### Context Map
```
## Context Map: {system name}

### Bounded Contexts
- **{Context A}**: {purpose}
- **{Context B}**: {purpose}

### Relationships
- {Context A} → [relationship pattern] → {Context B}
  {rationale for this pattern}
```

### Aggregate Design
```
## Aggregate: {name}

### Invariants
- {business rule that must always hold}

### Root Entity
- {name}: {identity, key attributes}

### Value Objects
- {name}: {what it represents, why it has no identity}

### Commands
- {command name}: {what it does, preconditions}

### Events
- {event name}: {what happened, what state changed}
```

### Bounded Context Canvas
Use the section structure described above under "Bounded Context Canvas."

## When NOT to Use DDD

DDD has cost. Apply it where domain complexity justifies the investment, and choose
simpler approaches everywhere else.

Signs DDD is overkill:
- The problem is CRUD with thin business rules. A direct, data-centric design is faster
  and clearer.
- The subdomain is generic. An off-the-shelf solution is preferable to modeling it.
- The team lacks ongoing access to domain experts. Without that collaboration, the
  ubiquitous language has no anchor and the model drifts toward developer assumptions.
- The system is short-lived (prototype, throwaway, single-use script). The model will
  not outlive the investment.
- Requirements are clear, narrow, and stable. The discovery mechanisms add no value
  when there is nothing to discover.

Signs DDD pays off:
- The domain is complex, with rules domain experts know and developers do not.
- The system is long-lived and will evolve as the business evolves.
- Multiple teams must work in parallel on related but distinct parts of the system.
- The cost of getting boundaries wrong is high — regulatory exposure, integration
  rework, scaling bottlenecks.

DDD is not all-or-nothing. Strategic patterns (context maps, bounded contexts,
ubiquitous language) can be valuable even when full tactical modeling would be
over-engineering. Apply the right depth to the right subdomain: core gets deep
modeling, supporting gets moderate treatment, generic gets minimal effort or a
purchased solution.

## Anti-Patterns to Avoid

### 1. Tactical Patterns Without Strategic Design
Modeling entities and aggregates without first understanding subdomains and bounded
contexts produces a technically structured codebase that models the wrong domain. Strategy
first, tactics second.

### 2. The God Aggregate
An aggregate that contains everything related to a concept (an Order that contains
Customer, Product catalog, Shipping rules, Payment processing). Aggregates protect
invariants — nothing more. If two things do not share an invariant, they belong in
separate aggregates.

### 3. Anemic Domain Model
Entities that are data bags with getters and setters, with all business logic in
services. The domain model should encapsulate behavior. If an entity has no methods
beyond accessors, the model is anemic.

### 4. Shared Data Model Across Contexts
A single "canonical" data model used by all services. This destroys bounded context
autonomy. Each context owns its model. Translation happens at the boundary through
anti-corruption layers, published language, or conformist patterns.

### 5. CRUD Thinking
Modeling every interaction as create/read/update/delete. Domain events like
"OrderPlaced", "ShipmentDispatched", "PaymentRefunded" carry business meaning that
"OrderUpdated" does not. If your events are all named "{Entity}Created" and
"{Entity}Updated", you are modeling data changes, not domain behavior.

### 6. Ignoring the Domain Experts
Building the model in isolation from the people who understand the business. DDD is a
collaborative discipline. The model emerges from conversations between domain experts
and developers. If your modeling sessions include only developers, the model will
reflect developer assumptions, not business reality.

## Decision Heuristics

Use these questions to navigate common DDD decisions:

**"Should this be an entity or a value object?"**
Does it have a lifecycle and identity that matters to the business? If you need to track
it over time and distinguish it from other instances with the same attributes, it is an
entity. If only its attributes matter and two instances with the same attributes are
interchangeable, it is a value object.

**"Should this be one aggregate or two?"**
Do the objects share an invariant — a business rule that must be enforced transactionally?
If yes, same aggregate. If not, separate aggregates referencing each other by identity.
Default to smaller aggregates; use eventual consistency between them.

**"Should this be a domain service or a method on an entity?"**
Does the operation naturally belong to a single entity? Put it there. Does it coordinate
across multiple entities or aggregates, or represent a domain concept that has no natural
home? Make it a domain service.

**"Where does this bounded context boundary go?"**
Look for linguistic boundaries — where the same word means different things to different
groups. Look for team boundaries — where different teams own different parts. Look for
business process boundaries — where one process hands off to another.

**"Which context mapping pattern should I use?"**
Consider the team dynamics and power relationships. Can both teams collaborate closely?
Partnership. Is one team upstream and responsive to downstream needs?
Customer-Supplier. Is one team upstream and unresponsive? The downstream team either
Conforms or builds an Anti-Corruption Layer. Is neither team willing to coordinate?
Separate Ways.

## Output Checklist

Before delivering any DDD artifact, verify:

- [ ] Every term uses the ubiquitous language of the relevant bounded context
- [ ] No technical jargon leaks into domain descriptions (no database, API, or
      framework terms in domain models)
- [ ] Subdomains are classified as core, supporting, or generic with rationale
- [ ] Each bounded context has a clear business purpose stated in one or two sentences
- [ ] Context map relationships include the pattern name and rationale
- [ ] Aggregates protect true invariants — no false invariants inflating aggregate size
- [ ] Aggregates are small — root entity plus only what must be transactionally consistent
- [ ] Entities are distinguished from value objects with clear reasoning
- [ ] Domain events are named in past tense and describe what happened in business terms
- [ ] No aggregate directly references another aggregate's internals (identity only)
- [ ] The model reflects the domain experts' understanding, not developer assumptions
- [ ] Cross-context communication uses explicit integration patterns (ACL, OHS/PL, etc.)
