# Example Mapping — Methodology Reference

> Sources: cucumber.io/blog/bdd/example-mapping-introduction/ (Matt Wynne, 2015), cucumber.io/docs/bdd/example-mapping/, cucumber.io/blog/bdd/your-first-example-mapping-session/ (Steve Tooke, 2018), cucumber.io/blog/bdd/gherkin-rules/, xebia.com/blog/example-mapping-steering-the-conversation/, automationpanda.com/2017/02/20/the-behavior-driven-three-amigos/, "Writing Great Specifications" by Kamil Nicieja (Manning, 2017), "Formulation" by Seb Rose & Gáspár Nagy (BDD Books)

## Table of Contents

1. [What Example Mapping Is](#what-example-mapping-is)
2. [The Four Card Types](#the-four-card-types)
3. [The Three Amigos Perspectives](#the-three-amigos-perspectives)
4. [Running a Session](#running-a-session)
5. [Readiness Heuristics](#readiness-heuristics)
6. [From Example Map to Gherkin](#from-example-map-to-gherkin)
7. [Anti-Patterns](#anti-patterns)

---

## What Example Mapping Is

Example Mapping is a structured conversation technique for reaching a shared understanding of what a capability should do before development begins. It was discovered by Matt Wynne (Cucumber co-founder) and is the recommended upstream step before writing Gherkin specifications.

The purpose is **discovery, not documentation**. The goal is to surface rules, illustrate them with concrete examples, and expose unresolved questions — all within a focused, time-boxed conversation. The output is a structured map that feeds directly into Gherkin formulation: rules become `Rule:` blocks, examples become `Scenario:` blocks, and questions become items to resolve before the capability is considered ready.

Example Mapping explicitly avoids Gherkin syntax during the session. Writing formal Given/When/Then too early stifles discovery by shifting the conversation from "what should happen?" to "how do I phrase this step?" Stay informal. Use natural language. Formulate into Gherkin afterward.

---

## The Four Card Types

Example Mapping uses four types of information, traditionally represented as colored index cards:

### Story (Yellow)

The capability being discussed. One per session. States what is being built and why, written from the user's perspective. This is the starting point — everything else hangs underneath it.

A story is **not** a user story in the "As a... I want... So that..." template. It is simply a clear statement of the capability under discussion.

### Rule (Blue)

A business rule, acceptance criterion, or constraint that governs how the capability behaves. Rules are discovered during the conversation — some are known upfront, others emerge as examples are discussed.

Rules should be:
- Stated in plain business language, not implementation terms
- Independent of each other where possible
- Specific enough to be illustratable with concrete examples
- Named descriptively so a reader understands the constraint without reading examples

A rule that cannot be illustrated with at least one example may be too vague. A rule with many examples may have multiple rules tangled together that need teasing apart.

### Example (Green)

A concrete, specific illustration of a rule in action. Examples make rules unambiguous by showing what happens in a particular situation. They are the raw material that will later become Gherkin scenarios.

Examples should:
- Be named using the "Friends episode" convention: "The one where..." followed by a short, memorable description of the specific situation
- Be concrete — use real-sounding data, names, amounts, not abstract placeholders
- Include both positive examples (the rule is satisfied) and negative examples (the rule is violated and the system refuses/rejects)
- Include boundary examples where a rule has a threshold or limit
- Stay informal — no Given/When/Then syntax yet

When the outcome of an example is unclear or disputed, it is not an example — it is a question. Move it to a red card.

### Question (Red)

Something nobody in the conversation can answer right now. An assumption being made. An uncertainty about expected behavior. A scenario where the right outcome is unknown.

Questions are **not failures** — they are the most valuable output of the session. Each question is an unknown-unknown turned into a known-unknown. Capturing questions and moving on (rather than debating opinions) keeps the conversation productive.

Questions may be:
- Behavioral: "What should happen when X occurs?"
- Scope: "Is Y in scope for this capability or a separate one?"
- Domain: "Does the business allow Z?"
- Dependency: "Does this require W to exist first?"

Some questions will be answered during the conversation (and become rules or examples). Others need investigation afterward. Questions that block development must be resolved before the capability moves forward.

---

## The Three Amigos Perspectives

Example Mapping is most effective when the conversation includes at least three perspectives. These are roles, not job titles — one person can play multiple roles, or multiple people can share a role.

### The Requester (Product / Business perspective)

Explains what the capability should do and why. Defines the business value. Sets the scope. Answers "is this in scope?" and "what does the user actually need?"

Typical contributions: initial rules, acceptance criteria, scope boundaries, priority of edge cases, domain knowledge about how the business works today.

### The Suggester (Development perspective)

Proposes how the capability might work. Identifies technical constraints, interactions with existing behavior, and feasibility concerns. Asks "how does this interact with X?" and "what happens to existing data/behavior?"

Typical contributions: constraints from the existing system, blast radius, state machine implications, performance considerations, dependency identification.

### The Protester (Testing / Quality perspective)

Challenges assumptions. Asks "what if...?" and "what else could go wrong?" Surfaces edge cases, boundary conditions, error scenarios, and negative paths. Ensures the map covers not just the happy path but the ways the capability might fail or behave unexpectedly.

Typical contributions: negative examples, boundary cases, race conditions, idempotency questions, error handling scenarios, "the one where everything goes wrong."

### In Multi-Agent Workflows

When Example Mapping is performed by AI agents rather than humans, each perspective can be assigned to a separate agent or handled as distinct passes over the capability. The key constraint is that **the perspectives must remain distinct** — an agent playing the Protester should not also answer its own questions. The human (or orchestrating agent) resolves conflicts and makes decisions.

A recommended multi-agent pattern:
1. An orchestrator reads the capability and produces the initial story card and any known rules
2. A requester-perspective agent reviews and refines rules from a business/product angle
3. A suggester-perspective agent adds constraints from the existing codebase or domain
4. A protester-perspective agent challenges each rule with negative examples, boundary cases, and "what if" questions
5. The orchestrator (or human) synthesizes the results, resolves conflicts, and produces the final map

Each agent should receive: the story card, the current state of rules and examples, and a clear brief on which perspective to take. Agents should output structured cards (rules, examples, questions) rather than prose discussion.

---

## Running a Session

### Before the Session

- Have a clear story statement (the yellow card). If the capability is vague, clarify it first — Example Mapping does not work on undefined ideas.
- Gather any known acceptance criteria or constraints. These become the initial blue cards.
- Identify who plays which perspective (or which agents, in a multi-agent workflow).

### During the Session

1. **Present the story.** Read the story card aloud. Ensure everyone understands the capability and its purpose.

2. **Lay out known rules.** Place any pre-existing acceptance criteria as blue cards. These are starting points, not final — they will be refined, split, or replaced during the conversation.

3. **Explore each rule with examples.** For each rule, ask: "Can you give me an example of this?" and "What's an example where this rule would prevent something?" Generate concrete examples (green cards) under the rule. Name each example with "The one where..."

4. **Surface questions.** When the outcome of an example is unclear, or when a "what if?" scenario has no agreed answer, capture it as a question (red card) and move on. Do not debate opinions — capture the uncertainty and continue.

5. **Discover new rules.** As examples are discussed, new rules will emerge that were not obvious at the start. Add blue cards as they surface. If an example does not fit under any existing rule, it probably reveals a new rule.

6. **Check for rule splits.** If a rule has many examples (more than 3-4), ask whether it actually represents multiple distinct rules tangled together. Tease them apart into separate blue cards.

7. **Check for story splits.** If the map is growing large (many blue cards), ask whether the capability should be split into multiple smaller capabilities. Create new yellow cards for deferred scope.

8. **Assess readiness.** When the conversation has explored all known aspects, assess whether the map is ready (see Readiness Heuristics below).

### After the Session

- Resolve open questions. Some may require domain expertise, user research, or technical investigation.
- The example map becomes input for Gherkin formulation. Rules become `Rule:` blocks. Examples become scenarios. Questions that were resolved during the session become rules or examples in the Gherkin file.
- Questions that remain unresolved block the capability from moving to specification.

---

## Readiness Heuristics

The shape of the example map itself tells you whether the capability is ready to move forward. These are visual heuristics when using physical cards — in text form, assess the same properties:

### Ready to proceed

- Every rule has at least one illustrative example
- Both positive and negative examples exist for rules that define boundaries
- Few or no unresolved questions remain (minor questions that can be resolved during development are acceptable)
- The map is a manageable size (roughly 3-7 rules)

### Not ready — too much uncertainty

- Many unresolved questions (red cards dominate). The capability needs more investigation before it can be specified. Send the requester to do homework and revisit.

### Not ready — too big

- Many rules (blue cards dominate). The capability is too large to specify as one unit. Split it into multiple capabilities, each with its own story card.

### Not ready — tangled rules

- A single rule has many examples (5+). The rule likely contains multiple distinct rules tangled together. Tease them apart before proceeding.

### Not ready — vague rules

- Rules exist but have no examples. The rule may be too vague to illustrate, or everyone assumes they understand it but actually have different mental models. Generate examples to expose the ambiguity.

---

## From Example Map to Gherkin

Example Mapping and Gherkin formulation are deliberately separate activities. Example Mapping is discovery; Gherkin formulation is documentation. The Gherkin `Rule:` keyword was created specifically to represent the blue cards from an example map.

The mapping is direct:
- **Story (yellow)** → `Feature:` title and description
- **Rule (blue)** → `Rule:` block within the feature file
- **Example (green)** → `Scenario:` (or `Example:`) within the rule block
- **Question (red)** → resolved before formulation, or flagged as a comment/open item

During formulation:
- Rewrite informal example names into descriptive scenario titles
- Express each example in Given/When/Then structure
- Add concrete data (the "Real Data" principle from BRIEF)
- Identify shared preconditions that belong in `Background`
- Apply all Gherkin best practices (declarative, business language, self-contained, etc.)

The person who understood the capability *least* before the Example Mapping session is often the best person to formulate the Gherkin — their formulation reveals whether the session successfully transferred understanding.

---

## Anti-Patterns

### Writing Gherkin during the session

Moving to formal Given/When/Then too early stifles discovery. Stay informal. Use "the one where..." names. Formulate into Gherkin afterward as a separate activity.

### Debating opinions instead of capturing questions

When the outcome of a scenario is unclear, people tend to argue about what *should* happen. Instead, capture it as a question and move on. The conversation should surface uncertainty, not resolve it through debate.

### Treating rules as implementation details

Rules should be stated in business language. "The database enforces a unique constraint on email" is an implementation detail. "Each account must have a unique email address" is a business rule.

### Skipping negative examples

If a rule only has positive examples ("the one where it works"), the boundary of the rule is undefined. Ask "what's an example where this rule would reject or prevent something?" to expose the negative path.

### One perspective dominates

If only the product perspective is represented, edge cases and technical constraints will be missed. If only the development perspective is represented, the business value and scope will be unclear. Ensure all three perspectives contribute.

### Mapping everything in one session

A well-sized capability should be mappable in roughly 25 minutes. If the session drags beyond that, the capability is either too big (split it) or too uncertain (defer it for investigation). Do not power through — listen to the signal.

### Confusing Example Mapping with specification

Example Mapping produces a structured *brief* — not a specification. The specification is the Gherkin feature file that is formulated from the brief. They are different activities requiring different mindsets (discovery vs. documentation).
