# Gherkin Best Practices, BRIEF Principles, and Anti-Patterns

> Sources: cucumber.io/docs/bdd/better-gherkin, cucumber.io/blog/bdd/keep-your-scenarios-brief/, cucumber.io/docs/guides/anti-patterns/

## Table of Contents

1. [The BRIEF Principles](#the-brief-principles)
2. [Declarative vs Imperative](#declarative-vs-imperative)
3. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
4. [Writing Quality Checklist](#writing-quality-checklist)

---

## The BRIEF Principles

Six principles for excellent Gherkin, forming the acronym BRIEF.

### B — Business Language

Every word in a scenario must come from the business domain. If a product owner would not use the term in a meeting, it does not belong in the feature file.

Anti-pattern: using ambiguous terms that mean different things in different contexts (e.g., "address", "account", "user") without qualification.

### R — Real Data

Use concrete, realistic data to expose boundary conditions and hidden assumptions. Avoid abstract placeholders.

Anti-pattern: relying on the existence of specific production data (e.g., a real customer ID that must exist in the database).

Good: `Given a customer named "Thrifty Thelma" with a balance of £42`
Bad: `Given User A with balance X`

### I — Intention-Revealing

Each scenario's purpose should be immediately obvious from its title and steps. A reader should understand the business rule without needing to read the step definition code.

Anti-pattern: generic scenario names like "Test 1", "Happy path", or "Verify login".

### E — Essential

Include only details that are essential to the behaviour being illustrated. Strip out all incidental information.

Anti-pattern: a scenario about a date-dependent rule that includes a time component when the time is irrelevant.

If a detail would not change the outcome if removed, remove it.

### F — Focused

Each scenario tests one and only one business rule. It should fail for exactly one reason.

Anti-pattern: scenarios that test multiple rules and could fail for several different reasons, making failures hard to diagnose.

### (BRIEF itself) — Brief

Scenarios should be short — ideally 3–5 steps. Long scenarios signal that either multiple behaviours are being tested, or incidental detail has crept in.

---

## Declarative vs Imperative

### Imperative (BAD)

Describes the exact UI steps a user takes. Tightly coupled to the current interface. Breaks when the UI changes.

```gherkin
# WRONG — imperative style
Scenario: Free subscriber sees free articles
  Given I am on the login page
  When I type "free@example.com" in the email field
  And I type "password123" in the password field
  And I press the "Submit" button
  Then I see "FreeArticle1" on the home page
  And I do not see "PaidArticle1" on the home page
```

Problems: tied to field names, button labels, page names. Any UI redesign breaks every scenario.

### Declarative (GOOD)

Describes the behaviour in business terms. Resilient to UI changes. Readable by non-technical stakeholders.

```gherkin
# RIGHT — declarative style
Scenario: Free subscriber sees only free articles
  Given Frieda has a free subscription
  When Frieda logs in with valid credentials
  Then she sees free articles
  But she does not see paid articles
```

### The 1922 Test

Imagine it is 1922 — no computers exist. If your scenario still makes sense as a description of a business process, it is declarative enough. If it requires a computer to make sense ("click", "enter in field"), it is too imperative.

### The Implementation Change Test

Ask: "Will this wording need to change if the implementation changes?" If yes, rewrite it to be more abstract.

---

## Anti-Patterns to Avoid

### 1. Incidental Details

Including data or steps that are irrelevant to the rule being tested. Every piece of information in a scenario should be there because the outcome depends on it.

Bad: specifying an email address, password complexity, and timezone when testing a shipping cost rule.

### 2. Technical / UI Leakage

Steps that reference buttons, fields, pages, URLs, HTTP methods, database tables, API endpoints, CSS selectors, JSON payloads, or any implementation artefact.

### 3. Feature-Coupled Step Definitions

Creating step definition files that mirror feature files 1:1. This prevents reuse and causes duplication. Organise step definitions by **domain concept**, not by feature file.

### 4. Conjunction Steps (And-Stuffing)

Steps that do two things joined by "and":

```gherkin
# BAD — two actions in one step
When the customer places an order and pays with a credit card
```

Split into separate steps:

```gherkin
When the customer places an order
And she pays with a credit card
```

### 5. One-Person Gherkin

Feature files written solely by one role (e.g., only by a product owner, or only by a developer). Gherkin should be a collaborative artefact produced during a discovery/specification workshop with input from business, development, and testing.

### 6. Testing Multiple Behaviours

A single scenario that verifies several unrelated outcomes. Each scenario should be focused on exactly one rule.

### 7. Overly Abstract Scenarios

The opposite of imperative — so vague that you cannot tell what the system actually does:

```gherkin
# TOO ABSTRACT
Scenario: The system works
  Given the system is set up
  When the user does something
  Then everything is fine
```

Find the balance: concrete enough to be meaningful, abstract enough to survive implementation changes.

### 8. Long Backgrounds

A `Background` section that is more than 4 lines long. If a reader has to scroll past the background to reach the first scenario, they have lost context. Use higher-level steps or split the feature file.

### 9. Scenarios as Test Cases

Writing Gherkin as if it were a test plan with setup, execution, teardown, and assertions. Feature files are **living documentation**, not test scripts. They describe behaviour, not test procedures.

### 10. Mixing Levels of Abstraction

Some steps are high-level ("the customer is logged in") while others in the same scenario are low-level ("I enter 'password' in the field"). Keep all steps at the same level of abstraction within a scenario.

---

## Writing Quality Checklist

When reviewing or writing a feature file, verify:

1. **Domain language only** — no tech, no UI, no API vocabulary leaks through.
2. **Declarative style** — steps describe _what_ happens, not _how_.
3. **One scenario = one rule** — each scenario can fail for only one reason.
4. **BRIEF compliance** — Business language, Real data, Intention-revealing, Essential details only, Focused, Brief length.
5. **Given/When/Then discipline** — `Given` sets up state (no interaction), `When` is the action (one per scenario), `Then` asserts observable outcomes (no internals).
6. **3–5 steps per scenario** — push shared setup into `Background`.
7. **Vivid names** — "Thrifty Thelma" not "User A"; "Guess the Word" not "Test Feature 3".
8. **No conjunction steps** — each step does one thing.
9. **Consistent abstraction level** — all steps sit at the same altitude.
10. **Background ≤ 4 lines** — short, shared, vivid.
