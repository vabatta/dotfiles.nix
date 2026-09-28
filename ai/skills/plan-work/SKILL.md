---
name: plan-work
description: "Use when asked to break work into tasks, sequence a change, or plan a multi-step effort. Produces verifiable units, a baseline to measure against, and a check per unit."
---

# Plan work

**Goal: turn a request into ordered, independently landable units, each with a check, and a baseline to measure against. Write the plan down before the work starts.**

## Definition of done

State the done condition as a falsifiable predicate. If no test, command, or read can return true or false for it, it is not a done condition.

## Harness and baseline

Build the verification harness and capture the baseline before touching the work. A unit with no before-and-after is not verifiable. See **principle-prove-it-works**.

## Decompose and sequence

Break the work into atomic units. Each unit lands on its own, and each ends in a state a reviewer can check without the next unit. Sequence riskiest-unknown-first. Write the unit list down.

Apply these as named references where their rules govern the shape:

- **principle-sequence-verifiable-units** for how units stack and land.
- **principle-foundational-thinking** for the core types and structures underneath.
- **principle-subtract-before-you-add** for what to remove before building.

## Fan out

Decide what fans out. Give each worker its own output through **delegate**.

## One-way doors

Route one-way-door design decisions to **architect** before sequencing around them.

## Return

Return the done predicate, the baseline, the ordered units with a check per unit, and what fans out.
