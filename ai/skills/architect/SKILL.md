---
name: architect
description: "Designs code before it is written, covering code shape, implementation internals, infrastructure, and data models, by grounding in the current system, settling one decision at a time, and ending in compilable stubs and failing tests for the build. Use when designing something new before writing code, not for a mechanical edit to an existing shape. Trigger on design this, discuss the design, architect this, sketch the types, design the interface, model the data, or design the infrastructure."
---

# Architect

Design before production code. Settle the shape decision by decision, then write it down as code that compiles and tests that fail. Architect writes no implementation. **build** fills the bodies against the sketch.

## Pick the variants

Read only the variants the work needs. A new system walks them in this order, because each one constrains the next: data-modeling, code-design, code-implementation. Infrastructure joins wherever the work runs, deploys, or is configured.

| Variant | Pick when |
|---|---|
| [data-modeling](references/variants/data-modeling.md) | New state, records, schema, wire or file format, or a change to who owns data |
| [code-design](references/variants/code-design.md) | New module, package, interface, or extension point, or a boundary moves |
| [code-implementation](references/variants/code-implementation.md) | The shape is fixed and the internals are not obvious: algorithm, control flow, error model, concurrency |
| [infrastructure](references/variants/infrastructure.md) | Runtime, deployment, CI, Nix, networking, secrets, or environments |

Done when the chosen variants and their order are named in one line.

## 1. Ground

Run **how** over every system the design touches, and **why** when the design moves ownership or layering, so the existing rationale becomes a constraint. Run **domain-modeling** when a term is fuzzy or overloaded. Skip only for greenfield work with nothing to integrate. Done when you can name the callers, the data, and the constraints the design must honour.

## 2. Frame the decisions

For each variant, list the decisions it must settle, using the variant's own list. Order them so no decision depends on one that is still open. Done when the decision list is written in the task list.

## 3. Settle each decision

Pick the mode once.

- **Discuss** when the user invoked this skill and is present. Work the decision list in **grill**'s rounds. For each decision give the recommendation, the strongest alternative, and the cost of each, all grounded in the facts found. The user decides. A pushback is new grounding: re-check the decisions downstream of it.
- **Compete** when another skill such as **figure-it-out** called this one, when no one is watching, when the user asks for options, or when two whole shapes survive discussion. Run **arena** with its code-design variant for every architect variant, since each candidate is still a sketch: types, schemas, config skeletons, or internal stubs with pseudocode. Competing working implementations are a separate route, not part of design. Give each runner [references/runner-prompt.md](references/runner-prompt.md) plus the chosen variant file, and add up to two rubric points from the variant to arena's default. Ask for the selected artifact only.
- An unproven fact under a decision goes to **prototype** first, in the variant that matches the doubt.

Screen the settled shape against [references/design-red-flags.md](references/design-red-flags.md). Prefer the shape that hides more behind a smaller surface. Done when every decision is settled or written as an assumption with its default, and the screen is clean or each flag is answered.

## 4. Write the sketch

Write the caller's usage first, then derive the types from it. Commit to the codebase in one change:

- types and signatures as compilable stubs, with the language's `not implemented` error for bodies and pseudocode for tricky logic;
- failing tests whose names state the behaviour;
- for infrastructure, the config or module skeleton plus the check that will prove it, such as a build, a plan, or a dry run.

Give the rationale in the reply, shaped per [references/rationale-template.md](references/rationale-template.md). Save each decision that is hard to reverse with **memory**. Write no design document and no ADR. Done when the stubs compile, the tests run and fail for the stated reason, and the rationale is given.

## 5. Hand off

Hand **build** the sketch, the rationale, and the assumptions. If building later shows the same deviation from the sketch again and again, the sketch is wrong: come back to step 1 with what was learned, redesign as if the new constraint had been there on day one, and make the new sketch smaller than the old one before it grows.

## Vocabulary

Use the module vocabulary in [references/deep-modules.md](references/deep-modules.md), not component, service, API, or boundary. [references/deepening.md](references/deepening.md) says how a dependency's kind decides the seam and the tests.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
