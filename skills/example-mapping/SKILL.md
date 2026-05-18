---
name: example-mapping
description: >
  Run structured Example Mapping sessions that produce specification briefs
  from rough capability descriptions. Use this skill whenever the user wants to
  discover business rules, explore edge cases, surface acceptance criteria, or
  prepare a capability for Gherkin specification. Also trigger when the user
  mentions "example mapping", "example map", "three amigos", "discovery session",
  "specification discovery", "rules and examples", "what are the acceptance
  criteria", or asks to "brainstorm the behavior" of a feature. Trigger even
  when the user says "what should this feature do", "help me think through the
  rules", "what are the edge cases", or "is this ready for spec". This skill
  covers the entire discovery conversation from rough idea to structured
  specification brief. It is the upstream step before Gherkin formulation —
  use it before the gherkin skill, not instead of it. When agents or workflows
  need to explore a capability before writing .feature files, this skill
  provides the structured conversation format.
---

# Example Mapping

You run structured Example Mapping sessions that transform rough capability
descriptions into specification briefs ready for Gherkin formulation.

Example Mapping is a discovery technique created by Matt Wynne (Cucumber
co-founder). It produces a structured map of **rules**, **examples**, and
**questions** that directly feeds into Gherkin feature files. It is the
recommended upstream step in the BDD workflow before writing `.feature` files.

**Your output is a specification brief, not Gherkin.** Gherkin formulation is a
separate activity handled by the gherkin skill. Your job is discovery — surface
what the capability should do, illustrate it with concrete examples, and expose
what is still unknown.

## Before You Begin

1. Read `references/example-mapping.md` for the **complete methodology
   reference**: card types, Three Amigos perspectives, session flow, readiness
   heuristics, and anti-patterns.
2. Apply every rule below on top of that reference.

## Core Principles (Non-Negotiable)

### 1. Discovery, Not Documentation

Example Mapping is a conversation for **discovering** what a capability should
do. It is not a specification-writing exercise. Stay in discovery mode
throughout. Do not write Gherkin. Do not design APIs. Do not discuss
implementation. Focus exclusively on **behavior from the user's perspective**.

### 2. Four Card Types Only

Every piece of information produced during the session must be one of exactly
four types. No other information type exists in an example map:

| Card | Color | Purpose | Format |
|------|-------|---------|--------|
| **Story** | Yellow | The capability being discussed | One clear statement of what and why |
| **Rule** | Blue | A business constraint or acceptance criterion | Plain-language rule statement |
| **Example** | Green | A concrete illustration of a rule | "The one where..." naming convention |
| **Question** | Red | An unresolved uncertainty | A specific, answerable question |

Everything captured during the session must be classifiable as one of these
four types. If something does not fit, it is either out of scope (defer it)
or needs to be rephrased until it fits.

### 3. Rules Before Examples

Always identify the rule before generating examples for it. An example without
a rule is unanchored — you cannot tell what it is illustrating. If an example
does not fit under any existing rule, it reveals a new rule. Add the rule first,
then place the example under it.

### 4. Informal Language — No Gherkin

Examples use the **"Friends episode" naming convention**: "The one where..."
followed by a short, memorable description of the specific situation.

Do not use Given/When/Then during Example Mapping. Formal syntax shifts the
conversation from "what should happen?" to "how do I phrase this step?" and
stifles discovery. Gherkin formulation happens afterward as a separate activity.

When more detail is needed for an example, use natural prose:
- Who is involved
- What situation they are in
- What they do
- What should happen

This is not Given/When/Then — it is a narrative sketch of the example.

### 5. Capture Questions, Don't Debate Opinions

When the outcome of an example is unclear or disputed, **do not argue about what
should happen**. Capture the uncertainty as a question (red card) and move on.
The session surfaces unknowns — it does not resolve them through debate.

Questions are the most valuable output. Each one is an unknown-unknown turned
into a known-unknown.

### 6. Three Perspectives

Every session must incorporate at least three perspectives on the capability:

**Requester (Product/Business):** What should this do? Why does it matter? What
is in scope? What does the user actually need?

**Suggester (Development):** How does this interact with existing behavior? What
are the technical constraints? What state transitions are involved? What
dependencies exist?

**Protester (Testing/Quality):** What if this goes wrong? What are the boundary
conditions? What negative examples exist? What assumptions are we making?

In a human conversation, these are people in the room. In a multi-agent
workflow, these are distinct passes or distinct agent briefs. The key constraint
is that **the perspectives must remain distinct** — the same agent should not
both raise and answer its own questions.

### 7. One Rule at a Time

Explore one rule completely (examples + questions) before moving to the next.
Do not jump between rules. This keeps the conversation focused and ensures
each rule is thoroughly explored before the group moves on.

## Session Flow

### Step 1: Frame the Story (Yellow Card)

State the capability in one clear sentence: what it does and who benefits.
This is the yellow card — everything else hangs underneath it.

If the input is a ticket, extract the capability statement from the ticket body.
If the input is a rough idea, ask the user to state the capability in one
sentence before proceeding.

The story card is **not** a user story template ("As a... I want... So that...").
It is a plain statement of the capability under discussion.

### Step 2: Lay Out Known Rules (Blue Cards)

Identify any rules that are already known — from the ticket body, from prior
conversations, from domain knowledge. State each as a plain-language business
rule and present them to the user.

Ask: "Are these the right rules? What's missing? What's wrong?"

These initial rules are starting points. They will be refined, split, or
replaced during the session. Do not treat them as final.

### Step 3: Explore Each Rule with Examples (Green Cards)

For each rule, generate concrete examples. Work through one rule at a time.

For each rule, produce:
- **At least one positive example** — "The one where the rule is satisfied and
  the expected behavior occurs"
- **At least one negative example** — "The one where the rule is violated and
  the system refuses, rejects, or prevents the action"
- **Boundary examples** where the rule has a threshold or limit — "The one where
  the value is exactly at the limit", "The one where the value is just below",
  "The one where the value is just above"

Name every example with "The one where..." followed by a concise, memorable
description.

Present examples to the user per rule. Ask: "Do these examples capture the
rule correctly? What other situations should we consider?"

### Step 4: Surface Questions (Red Cards)

As examples are discussed, questions will emerge. Capture each question as a
red card. Questions fall into several categories:

- **Behavioral:** "What should happen when X occurs?"
- **Scope:** "Is Y in scope for this capability or a separate one?"
- **Domain:** "Does the business allow Z?"
- **Dependency:** "Does this require W to exist first?"
- **Conflict:** "What if this contradicts existing behavior A?"

Do not try to answer questions through debate. If the answer is known, it
becomes a rule or an example. If the answer is unknown, it stays as a question.

### Step 5: Discover New Rules

As examples and questions are explored, new rules will emerge that were not
obvious at the start. When an example does not fit under any existing rule,
it reveals a new rule. Add the rule, then place the example under it.

### Step 6: Check for Splits

After all known aspects have been explored, assess the map's shape:

- **A rule with many examples (5+):** likely contains multiple distinct rules
  tangled together. Tease them apart into separate rules.
- **Many rules (8+):** the capability is too large. Split it into multiple
  capabilities, each with its own story card. Deferred capabilities become
  separate items.

### Step 7: Assess Readiness

Apply the readiness heuristics from the reference document:

- **Ready:** every rule has examples (positive + negative), few/no unresolved
  questions, manageable size (3-7 rules)
- **Not ready — uncertain:** many unresolved questions. Needs investigation.
- **Not ready — too big:** many rules. Needs splitting.
- **Not ready — tangled:** rules with many examples. Needs teasing apart.
- **Not ready — vague:** rules without examples. Needs concretizing.

State the readiness assessment explicitly to the user.

### Step 8: Produce the Specification Brief

When the map is ready, produce the deliverable: a structured specification
brief. Use this exact format:

```
## Story

{One-sentence capability statement}

## Rules and Examples

### Rule: {plain-language rule statement}

- The one where {positive example}
- The one where {negative example}
- The one where {boundary example, if applicable}

### Rule: {next rule}

- The one where {example}
- The one where {example}

{repeat for each rule}

## Questions

- {unresolved question — must be answered before Gherkin formulation}
- {unresolved question}

## Deferred

- {capability sliced off for a separate ticket/session}
```

Present the brief to the user. Ask: "Does this capture everything? Any rules
missing? Any examples that don't feel right?"

Iterate until the user approves.

## Multi-Agent Usage

When Example Mapping is used in a multi-agent workflow (orchestrator + focused
agents), follow these patterns:

### Agent Briefs

Each agent receives a brief containing:
1. The story card (yellow)
2. The current state of rules and examples
3. Which perspective to take (requester, suggester, or protester)
4. Clear instruction to output structured cards, not prose discussion

### Agent Outputs

Each agent returns structured output in this format:

```
RULES:
- {rule statement}
- {rule statement}

EXAMPLES:
- Under rule "{rule name}": The one where {example}
- Under rule "{rule name}": The one where {example}

QUESTIONS:
- {question}
- {question}
```

### Orchestrator Responsibilities

The orchestrator (or human):
1. Frames the story card and gathers initial rules
2. Dispatches perspectives to agents sequentially or in parallel
3. Merges agent outputs — deduplicates rules, places examples under rules,
   collects all questions
4. Resolves conflicts between agent outputs (or presents conflicts to the human)
5. Runs the readiness assessment
6. Produces the final specification brief

### Key Constraint

An agent playing the Protester should not also answer its own questions. The
perspectives must remain distinct. If an agent raises a question, a different
agent (or the human) resolves it.

## What This Skill Does NOT Do

- **Does not write Gherkin.** The gherkin skill handles formulation.
- **Does not design APIs.** API design is a separate downstream activity.
- **Does not make implementation decisions.** Rules describe behavior, not
  implementation. "The system rejects the request" is a rule. "The database
  raises a unique constraint violation" is an implementation detail.
- **Does not replace the human.** In human-in-the-loop workflows, the human
  controls every gate — approves rules, adds examples, answers questions,
  and decides when the map is ready.

## Output Checklist

Before delivering a specification brief, verify every item:

- [ ] The story card states the capability and its purpose in one sentence
- [ ] Every rule is stated in plain business language, not implementation terms
- [ ] Every rule has at least one positive and one negative example
- [ ] Rules with thresholds or limits have boundary examples
- [ ] All examples use "The one where..." naming, not Given/When/Then
- [ ] Unresolved questions are captured explicitly as red cards
- [ ] No rule has more than 4-5 examples (split tangled rules)
- [ ] The total number of rules is manageable (3-7 per capability)
- [ ] Deferred/sliced capabilities are listed separately
- [ ] The readiness assessment has been stated explicitly
- [ ] No Gherkin syntax appears anywhere in the output
- [ ] No implementation details appear in rules or examples
