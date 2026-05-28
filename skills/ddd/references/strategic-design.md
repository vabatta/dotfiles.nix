# Strategic Design Reference

> Sources: Eric Evans — "Domain-Driven Design" (2003), Vaughn Vernon — "Implementing
> Domain-Driven Design" (2013), Vlad Khononov — "Learning Domain-Driven Design" (2021),
> Scott Millett & Nick Tune — "Patterns, Principles, and Practices of Domain-Driven
> Design" (2015), ddd-crew/context-mapping (GitHub), Nick Tune — Bounded Context Canvas,
> Alberto Brandolini — Event Storming, contextmapper.org

## Table of Contents

1. [Subdomains](#subdomains)
2. [Bounded Contexts](#bounded-contexts)
3. [Ubiquitous Language](#ubiquitous-language)
4. [Context Mapping Patterns](#context-mapping-patterns)
5. [Core Domain Distillation](#core-domain-distillation)
6. [Event Storming for Strategic Discovery](#event-storming-for-strategic-discovery)
7. [Domain Storytelling](#domain-storytelling)
8. [Bounded Context Canvas](#bounded-context-canvas)
9. [Heuristics for Finding Boundaries](#heuristics-for-finding-boundaries)

---

## Subdomains

A subdomain is a segment of the business domain. Every organization's domain can be
decomposed into subdomains. The decomposition is driven by the business, not by
technology.

### Three Types

**Core Subdomain**
The part of the domain that provides competitive advantage. It contains complex,
unique business logic that differentiates the organization. Core subdomains justify
the full investment of DDD rigor — deep modeling, the best developers, continuous
refinement.

Characteristics: complex logic, unique to this business, cannot be bought off the
shelf, changes frequently as the business evolves, delivers the most business value.

Example: Uber's route optimization algorithm, YouTube's recommendation engine, a
trading firm's pricing model.

**Supporting Subdomain**
Necessary for the business to operate but not a differentiator. Supporting subdomains
have moderate complexity and custom logic, but another company doing the same thing
would not lose competitive advantage.

Characteristics: moderately complex, somewhat custom but not unique, could theoretically
be outsourced, supports the core but is not the core.

Example: An e-commerce company's inventory tracking — essential, but not what makes
the company special.

**Generic Subdomain**
A solved problem that every organization handles the same way. Authentication, email
sending, payment processing (via a gateway), logging, CRUD administration panels.

Characteristics: well-understood problem, off-the-shelf solutions exist, no competitive
advantage in building it yourself, commoditized.

Example: Authentication (use an identity provider), email delivery (use a mail service),
basic invoicing (use accounting software).

### Classification Decision Tree

Ask these questions in order:

1. Can you buy or adopt an off-the-shelf solution without losing competitive advantage?
   → **Generic**
2. Is the business logic simple or moderately complex, and not a differentiator?
   → **Supporting**
3. Is the logic complex, unique, and central to what makes this business succeed?
   → **Core**

A subdomain's classification can change over time. Yesterday's core innovation becomes
today's commodity. Reassess periodically.

### Investment Strategy by Type

| Subdomain | Modeling Depth | Team Skill | Build vs Buy |
|-----------|---------------|------------|--------------|
| Core | Deep DDD modeling | Best developers | Always build |
| Supporting | Moderate modeling | Competent developers | Build or outsource |
| Generic | Minimal modeling | Any | Buy, adopt, or outsource |

---

## Bounded Contexts

A bounded context is a boundary within which a particular domain model is defined and
applicable. Inside the boundary, every term has a precise, unambiguous meaning. Outside
it, the same term may mean something entirely different.

### Bounded Context ≠ Subdomain

Subdomains are a problem-space concept (how the business is structured). Bounded contexts
are a solution-space concept (how the software is structured). Ideally they align one-to-one,
but in practice a subdomain may be served by multiple bounded contexts, or a legacy system
may bundle multiple subdomains into a single bounded context.

### Identifying Bounded Contexts

**Linguistic boundaries:** When the same word means different things to different groups,
you have found a context boundary. "Account" means one thing in banking (a financial
instrument) and another in identity management (a user credential). "Product" means one
thing in the catalog (a description with images and specs) and another in the warehouse
(a physical item with a shelf location and quantity).

**Team boundaries:** Different teams often work on different contexts. If two teams
must constantly coordinate on the meaning of shared terms, they either share a context
(and should be one team) or they need an explicit integration pattern between their
contexts.

**Business process boundaries:** When one process hands off to another — "ordering"
to "fulfillment", "claims intake" to "claims adjudication" — each process is a
candidate for a separate bounded context.

**Consistency boundaries:** Where a set of business rules must be enforced transactionally,
that is at minimum one bounded context. Where eventual consistency is acceptable, a
separate context is possible.

### The One-Team-Per-Context Principle

A bounded context should be owned by exactly one team. A team may own multiple contexts,
but a context should not be shared across teams. Shared ownership dilutes the ubiquitous
language and introduces coordination overhead that erodes model integrity.

---

## Ubiquitous Language

The ubiquitous language is the shared vocabulary between domain experts and developers
within a single bounded context. It appears in conversations, documentation, code (class
names, method names, variable names), and tests.

### Rules

- The language is scoped to a bounded context. There is no "universal" ubiquitous language
  across the entire organization.
- If a term is ambiguous, the model is ambiguous. Resolve it.
- If domain experts do not recognize a term in the codebase, the code has drifted from
  the domain.
- Developers should speak the domain language in meetings. Domain experts should recognize
  the language in the code.

### False Cognates

A false cognate is a term that looks the same across contexts but carries different
meaning or rules. "Order" in the Sales context (a commitment to purchase) is not the
same as "Order" in the Warehouse context (a pick list). Forcing a single definition
creates a leaky abstraction. Let each context own its definition.

---

## Context Mapping Patterns

Context mapping captures the relationships between bounded contexts. The relationships
describe how teams and their models integrate. There are nine widely recognized patterns,
organized along two axes: the degree of **control** one team has over another, and the
degree of **communication** between teams.

### Symmetric Patterns (No Upstream/Downstream)

**Partnership**
Two teams with mutually dependent contexts. Their software must be delivered together
to succeed. Both teams coordinate closely, planning and releasing in sync.

When to use: Two contexts that evolve in lockstep and whose success depends on each
other. Both teams are willing and able to coordinate closely.

Risk: High communication overhead. Works only with small, co-located teams.

**Shared Kernel**
Two or more contexts share a small, common subset of the model — a shared library,
schema, or code module. Changes to the shared kernel require agreement from all owning
teams.

When to use: When a small, stable piece of the model is genuinely shared and the
cost of duplication exceeds the cost of coordination.

Risk: The kernel tends to grow over time, increasing coupling. Keep it as small as
possible. The moment the kernel becomes contentious, consider splitting.

### Upstream/Downstream Patterns

In an upstream-downstream relationship, the upstream context's actions affect the
downstream context, but not vice versa. The upstream team can succeed independently;
the downstream team depends on the upstream's model.

**Customer-Supplier**
The upstream team (supplier) considers the downstream team's (customer) needs when
planning. The downstream's priorities factor into the upstream's roadmap. There is a
negotiated interface.

When to use: When the upstream team is responsive to the downstream team's needs and
both teams benefit from a collaborative relationship.

**Conformist**
The downstream team conforms to the upstream team's model without negotiation. The
upstream team has no motivation or ability to accommodate the downstream's needs.

When to use: When integrating with a large, established system (an ERP, a dominant
platform API) where the upstream will not change for you. Or when the upstream model
is good enough that conforming is cheaper than translating.

Risk: The downstream context's model is compromised. It cannot evolve its language
independently.

**Anti-Corruption Layer (ACL)**
The downstream team builds a translation layer that isolates its model from the
upstream's. The ACL converts upstream concepts into the downstream's ubiquitous
language.

When to use: When the upstream model is unsuitable, legacy, or likely to change in
ways that would break the downstream. When you cannot conform and cannot influence
the upstream.

This is the most common defensive pattern and the default choice when integrating
with systems you do not control.

**Open Host Service (OHS)**
The upstream context exposes a well-defined protocol (API, event stream) that any
downstream can consume. The protocol is designed for broad consumption, not tailored
to any single downstream.

When to use: When an upstream context has many downstream consumers. The OHS provides
a stable, documented interface rather than point-to-point integrations.

**Published Language (PL)**
A well-documented, shared data format used for integration. JSON schemas, Protobuf
definitions, Avro schemas, XML schemas. Published Language often accompanies an Open
Host Service.

When to use: When an OHS needs a formal, versioned schema for its messages.

### No-Integration Patterns

**Separate Ways**
Two contexts have no integration at all. Each operates independently. This is appropriate
when the cost of integration exceeds its value, or when two contexts simply have no
business need to communicate.

When to use: When you evaluate the integration cost and decide it is not worth it.
Users may need to manually bridge the gap (re-entering data, for instance), and that is
acceptable.

### Deciding Which Pattern to Use

Ask these questions:

1. **Is there a power imbalance?** If the upstream team will not accommodate you,
   choose between Conformist (their model is acceptable) and ACL (their model is not).
2. **Are both teams equally invested?** Partnership or Shared Kernel.
3. **Does the upstream serve many consumers?** OHS with Published Language.
4. **Is integration not worth the cost?** Separate Ways.
5. **Can you negotiate the interface?** Customer-Supplier.

### Drawing a Context Map

A context map is a diagram showing all bounded contexts and the integration patterns
between them. It is not a technical architecture diagram — it captures team relationships
and model dependencies.

Notation conventions:
- Boxes for bounded contexts (labeled with the context name)
- Lines between them labeled with the pattern (U = upstream, D = downstream)
- Arrows indicate the direction of influence (upstream → downstream)

```
[Sales Context] ---U/D Customer-Supplier--- [Fulfillment Context]
[Fulfillment Context] ---U/D ACL--- [Legacy Warehouse System]
[Identity Context] ---OHS/PL--- [All Contexts]
[Analytics Context] ---Separate Ways--- [Support Context]
```

---

## Core Domain Distillation

Distillation is the process of clarifying the core domain by separating it from
supporting and generic concerns. Eric Evans describes several distillation techniques:

**Domain Vision Statement** — A short document (one page) describing the core domain's
value proposition and how it differs from other subdomains. It serves as a north star
for the team.

**Highlighted Core** — Mark the elements of the model that belong to the core domain.
This can be as simple as a document listing the core modules, or annotations in the code.

**Generic Subdomain Extraction** — Identify subdomains that are not core and extract
them into separate modules or services. Options include buying off-the-shelf, using
open source, or building simple custom solutions.

**Cohesive Mechanism** — Extract complex computational logic that serves the domain
but is not itself domain knowledge (e.g., a graph traversal algorithm, a scheduling
engine) into a separate module with an intention-revealing interface.

**Segregated Core** — Refactor the core domain into its own module(s), moving everything
non-core out. This may temporarily make non-core parts harder to work with, but the
benefit of a clear, focused core outweighs that cost.

---

## Event Storming for Strategic Discovery

Event Storming at the Big Picture level is the most effective technique for discovering
bounded context boundaries. The workshop proceeds in roughly these phases:

1. **Chaotic Exploration** — Everyone writes domain events (orange sticky notes, past
   tense) and sticks them on the wall. No order, no filtering.

2. **Enforce the Timeline** — Arrange events chronologically from left to right.
   Duplicates merge, gaps surface, debates happen.

3. **Identify Hotspots** — Mark pain points, bottlenecks, and areas of disagreement
   with pink/red sticky notes.

4. **Add Commands and Actors** — For each event, identify the command that triggered
   it (blue) and the actor who issued the command (yellow).

5. **Add Policies** — Identify automation rules: "When X happens, then Y" (purple).

6. **Identify Aggregates** — Group events and commands that belong to the same
   consistency boundary (light yellow).

7. **Draw Boundaries** — Look for natural clusters. Where the language changes, where
   different teams own different clusters, where events cross from one process to
   another — these are bounded context boundaries.

### Boundary Signals During Event Storming

- **Language shifts:** The same event described differently by different participants
- **Ownership changes:** Different people claim authority over different clusters
- **Pivot events:** Events that hand off from one process to another
- **Temporal gaps:** Long pauses between event clusters suggest process boundaries

---

## Domain Storytelling

Domain Storytelling, created by Stefan Hofer and Henning Schwentner, is a collaborative
modeling technique in which domain experts narrate concrete stories about how the
business operates, and a moderator captures them in a small pictographic language. It
is complementary to Event Storming and often more accessible to non-technical
stakeholders.

### Pictographic Language

- **Actor** — a person, role, or system that performs work
- **Work Object** — a document, message, artifact, or concept the actor manipulates
- **Activity** — a verb describing what happens, numbered to convey order
- **Arrow** — directed connection from actor to work object (or back) labeled with the
  activity and its sequence number
- **Annotation** — free-text notes attached to clarify intent, constraints, or
  exceptions
- **Group** — a visual cluster of related elements; candidate boundary for a subdomain
  or bounded context

### Story Properties

Each story is scoped along three dimensions, fixed before the session begins:

- **Point of view** — whose perspective is being narrated (one role, not many)
- **Scope** — coarse (whole process) or fine (a single step)
- **Time** — as-is (how it works today), to-be (how it should work), or hypothetical
  (what-if exploration)

Mixing perspectives, scopes, or time frames within a single story produces confusion.
Each combination is a separate story; multiple stories together form a map.

### Use in Strategic Design

- **Boundary discovery:** Visual groups that recur across multiple stories suggest
  bounded contexts. Sharp handoffs between groups indicate context boundaries.
- **Language elicitation:** The vocabulary used in stories surfaces the ubiquitous
  language and any false cognates between roles.
- **As-is vs to-be analysis:** Telling the same story from both time frames exposes
  where redesign is needed.
- **Cross-check Event Storming:** Where an event storm shows a panoramic timeline,
  storytelling drills into the concrete path one actor traverses. Disagreements
  between the two often mark hotspots worth investigating.

### When to Choose Storytelling vs Event Storming

| Situation | Prefer |
|-----------|--------|
| Stakeholders find chaos overwhelming | Domain Storytelling |
| Need a panoramic view of many flows | Event Storming |
| Onboarding into an unfamiliar domain | Domain Storytelling |
| Surfacing hotspots, policies, and aggregates | Event Storming |
| Comparing as-is to to-be processes | Domain Storytelling |
| Exploring the entire business in one workshop | Event Storming |

The two techniques are not exclusive. Many teams use storytelling first to build shared
understanding, then event storming to broaden coverage and surface design opportunities.

---

## Bounded Context Canvas

The Bounded Context Canvas (created by Nick Tune, maintained by the DDD Crew) is a
structured template for designing and documenting a bounded context after it has been
identified.

### Canvas Sections

**Name** — The context's name, agreed upon by the team.

**Purpose** — A few sentences describing the business value this context provides.
No technical details. Written so a non-technical stakeholder can understand it.

**Strategic Classification:**
- Domain type: Core / Supporting / Generic
- Business model: Revenue-generating / Cost-reducing / Compliance / Engagement
- Evolution: Genesis / Custom-built / Product / Commodity (Wardley Maps terminology)

**Domain Roles** — The behavioral archetype. Options include:
- **Execution:** Enforces a business process (e.g., order processing)
- **Analysis:** Crunches data to produce insights (e.g., recommendation engine)
- **Gateway:** Translates between internal and external systems (e.g., payment gateway)
- **Autonomy:** Operates independently with minimal integration (e.g., self-service portal)

**Inbound Communication** — Commands and queries the context accepts. Who sends them?
What messages arrive?

**Outbound Communication** — Events and responses the context publishes. Who consumes
them? What messages leave?

**Ubiquitous Language** — The key terms and their precise definitions within this context.

**Business Decisions** — The domain rules and policies the context enforces.

**Assumptions** — What the team believes but has not verified.

**Open Questions** — What remains unknown and must be resolved.

**Dependencies** — Which other contexts supply messages inbound? Which contexts consume
messages outbound?

---

## Heuristics for Finding Boundaries

These heuristics help when you are stuck on where to draw bounded context boundaries.

### Linguistic Heuristic
When two groups use the same word with different meaning (or different words for the
same concept), that divergence marks a boundary. Do not unify the language — separate
the contexts.

### Process Heuristic
Each end-to-end business process (onboarding, ordering, claims processing) is a
candidate for one or more bounded contexts. Hand-off points between processes are
natural boundaries.

### Organizational Heuristic
Align boundaries with team ownership. If a team cannot own the entire context, the
boundary is in the wrong place.

### Data Lifecycle Heuristic
Data that is created in one process and consumed (read-only) in another suggests
separate contexts. The creating context is upstream; the consuming context is downstream.

### Volatility Heuristic
Parts of the domain that change at different rates should be in separate contexts.
A pricing engine that changes weekly should not be in the same context as a customer
profile that changes rarely.

### Consistency Heuristic
If two concepts must be transactionally consistent, they belong in the same aggregate
(and likely the same context). If eventual consistency is acceptable, they can be in
separate contexts.

### Regulatory Heuristic
Compliance boundaries (PCI, GDPR, HIPAA) often force context boundaries. Data subject
to regulation should be isolated in its own context with strict access controls.
