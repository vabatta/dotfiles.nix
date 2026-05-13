---
name: gherkin
description: >
  Write production-quality Gherkin `.feature` files that follow all modern best practices.
  Use this skill whenever the user asks to write, review, fix, or generate Gherkin scenarios,
  Cucumber feature files, BDD specifications, acceptance criteria in Given/When/Then format,
  or anything involving `.feature` files. Also trigger when the user mentions "BDD", "behaviour-driven",
  "behavior-driven", "Given/When/Then", "scenario outline", "feature file", "acceptance test scenarios",
  "executable specification", or asks to convert requirements/user stories into Gherkin.
  Even if the user just says "write tests for this feature" or "turn these requirements into scenarios",
  use this skill — it covers all Gherkin authoring.
---

# Gherkin Feature File Authoring

You write `.feature` files using the Gherkin language (the syntax understood by Cucumber and compatible BDD frameworks). Your output must read as **living documentation** — plain-English specifications that any stakeholder (product owner, developer, tester) can understand without technical knowledge.

## Before You Write Anything

1. Read `references/gherkin-syntax.md` for the **complete keyword reference and structural rules**.
2. Read `references/best-practices.md` for **style rules, anti-patterns, and the BRIEF principles**.
3. Apply every rule below on top of those references.

## Core Principles (Non-Negotiable)

### 1. Natural Language Only — Zero Technical Leakage

Feature files are **business documents**, not test scripts. Every word must come from the problem domain.

**Forbidden in steps:**
- UI elements: buttons, fields, links, dropdowns, modals, forms, pages, URLs, CSS selectors
- API/tech terms: endpoint, payload, request, response, status code, JSON, REST, database, query, SQL, HTTP
- Programmatic actions: click, type, enter, submit, navigate, scroll, invoke, call, assert
- Infrastructure: server, cache, queue, microservice, container, deployment, pipeline

**Instead, describe _what happens_ in business terms:**

```gherkin
# WRONG — imperative, UI-coupled
When I click the "Login" button
And I enter "alice" in the "username" field
And I enter "secret" in the "password" field
Then I should see the "Dashboard" page

# RIGHT — declarative, behaviour-focused
When Alice logs in with valid credentials
Then she sees her personal dashboard
```

```gherkin
# WRONG — technical leakage
Given a POST request to "/api/orders" with JSON body
Then the response status code should be 201

# RIGHT — domain language
Given Alice places an order for 2 items
Then the order is confirmed
```

### 2. Declarative Over Imperative

Describe **what** the system does, not **how** a user operates the interface. Imagine it is 1922 and there are no computers — the scenario should still make sense.

Each step should express a single business-meaningful action or assertion, not a sequence of keystrokes or clicks.

### 3. One Scenario = One Behaviour

Each scenario tests exactly **one** business rule or acceptance criterion. It should fail for exactly **one** reason. If you find yourself testing multiple outcomes, split into separate scenarios.

### 4. The Given/When/Then Contract

| Keyword | Purpose | Tense | Rule |
|---------|---------|-------|------|
| `Given` | Establish preconditions — the world _before_ the action | Past / present state | No user interaction here |
| `When`  | The single action or event under test | Present — the thing that happens | Exactly one `When` block per scenario |
| `Then`  | Observable outcomes — what the user/system _sees_ | Future expectation | Only **observable** outputs, never database internals |

Use `And` / `But` for continuation. Never repeat the parent keyword (`Given … Given`); use `And` instead.

### 5. Scenario Length

Aim for **3–5 steps** per scenario. If you exceed 5 steps, the scenario likely tests more than one behaviour or contains incidental detail. Push complexity into `Background` or higher-level step abstractions.

### 6. Feature File Structure

Every `.feature` file follows this skeleton:

```
@optional_tag
Feature: <Short business capability name>
  <1–3 line plain-English description of the business value or rule>

  Background:             # Optional — shared preconditions
    Given <common setup>

  Rule: <Business rule>   # Optional — groups related scenarios under a rule

    Scenario: <Descriptive name of the specific behaviour>
      Given <precondition>
      When <action>
      Then <outcome>
```

### 7. Naming Conventions

- **Feature title**: a noun phrase describing the capability (e.g., `Feature: Account Withdrawal`)
- **Scenario title**: describes the specific behaviour being illustrated, not the test (e.g., `Scenario: Overdraft is declined when balance is insufficient`)
- **Rule title**: states the business rule in plain language (e.g., `Rule: Withdrawals cannot exceed the available balance`)
- Avoid generic names like `Scenario: Test login` or `Scenario: Happy path`.

### 8. Scenario Outlines

Use `Scenario Outline` with an `Examples` table when the **same behaviour** applies across multiple data sets. Parameters use `< >` delimiters:

```gherkin
Scenario Outline: Shipping cost depends on order total
  Given a cart with a total of <total>
  When the customer proceeds to checkout
  Then the shipping cost is <shipping>

  Examples:
    | total   | shipping |
    | £25.00  | £5.99    |
    | £50.00  | £2.99    |
    | £100.00 | £0.00    |
```

Do **not** use outlines to test fundamentally different behaviours — write separate scenarios instead.

### 9. Background

Use `Background` only for `Given` steps shared by **every** scenario in the feature (or rule). Keep it short (≤ 4 lines). If the background has scrolled off screen, the reader has lost context.

Use vivid, memorable names in backgrounds (e.g., `Given a customer named "Thrifty Thelma"`) rather than abstract placeholders (`"User A"`).

### 10. Tags

Use tags for cross-cutting concerns: `@smoke`, `@wip`, `@slow`, `@billing`, `@regression`. Place them above `Feature`, `Rule`, or `Scenario` lines. Never use tags to encode test data or implementation details.

### 11. Data Tables and Doc Strings

Use a **Data Table** when a step needs structured multi-field input:

```gherkin
Given the following users exist:
  | name  | role    |
  | Alice | admin   |
  | Bob   | viewer  |
```

Use a **Doc String** (triple-quoted block) for free-form text content:

```gherkin
Given a blog post with the body:
  """
  Welcome to our new site.
  We are glad to have you.
  """
```

### 12. Comments

Use `#` comments sparingly — only to explain _why_ a scenario exists if the title and steps are not self-evident. Never use comments to explain _how_ — that belongs in step definitions.

## Output Checklist

Before delivering any `.feature` file, verify every item:

- [ ] Every step uses domain language; zero UI/tech/API terms leak through
- [ ] Every scenario has exactly one `When` block
- [ ] Scenarios are 3–5 steps long
- [ ] `Background` contains only universally shared `Given` steps
- [ ] Scenario titles describe the behaviour, not the test mechanism
- [ ] `Scenario Outline` parameters are meaningful domain values
- [ ] `And`/`But` are used instead of repeating `Given`/`When`/`Then`
- [ ] No scenario tests more than one business rule
- [ ] `Then` steps assert only observable outputs (never database/internal state)
- [ ] The file would make sense to a non-technical stakeholder reading it cold
