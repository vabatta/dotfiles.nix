# Agents

**Pick when:** an agent reads it: a skill, AGENTS.md, CLAUDE.md, a system prompt, or a file a skill points to. Use it also when an agent keeps misreading its instructions.

This applies to any document an agent consumes, a skill, an `AGENTS.md`, or a file reached by a pointer. The goal is a predictable process every run, not identical output. For the mechanics of creating and evaluating a skill, use Anthropic's skill-creator skill where the harness provides it, and read [skill-mechanics.md](../skill-mechanics.md) when the document is a skill, for invocation, splitting, and routers.

## Context pointers

A pointer is a reference in agent context that names out-of-context material and the condition to reach it. A skill description and an `AGENTS.md` line are pointers. Wording, not the target, decides triggering, so a must-have target behind weak wording is a variance bug. Sharpen the wording, and inline the material only if sharpening fails. A pointer states what the material is and lists the branches that trigger it. Front-load the leading word, keep one trigger per branch, and cut identity the body already carries.

## The two loads

Context load is the always-loaded tokens, an `AGENTS.md` line or a description. Cognitive load is the human's memory of which document exists when. The human is the index. Pointer-only material escapes context load at the cost of the pointer line. With no pointer, all of it is cognitive load.

## Information hierarchy

Separate steps, which are ordered actions, from reference, which is consulted on demand. The ladder is an in-file step, then in-file reference, then reference disclosed behind a pointer. Progressive disclosure means moving down the ladder. Branching is the disclosure test, inline what every branch needs and disclose what only some reach. Co-locate a concept's definition, rules, and caveats. A document over 500 lines is sprawl, and the cure is the ladder.

## Steps and completion criteria

Every step ends on a completion criterion, so the agent can tell done from not-done. Premature completion is pulled by visible post-completion steps. Fix the bound first, and split the sequence only across a real context boundary. The best criteria are checkable and exhaustive.

## Leading words and pruning

A leading word is a compact pretrained concept the agent thinks with, repeated as a token. Prefer an existing word over a coined one, and refactor restatements into one token. Prohibitions make the behavior more available, so prompt the positive and keep a ban only as an unphraseable hard guardrail. Keep a single source of truth and delete no-ops, the instructions the model already obeys.

## Procedure

1. Name the document and its caller. Done when you can say who reads it and when.
2. For each section, apply the matching rule above: pointer wording, ladder placement, completion criterion, leading word. Done when every step ends on a checkable criterion.
3. Delete no-ops and restatements. Done when each remaining instruction changes agent behavior.
4. Re-read the diff. Done when the document is shorter or equal in length and no must-have pointer lost its trigger.

The voice pass applies here without its "adding soul" part: cut the patterns, since filler costs tokens and attention, but add no opinion or first person.
