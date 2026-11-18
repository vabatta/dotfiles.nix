---
name: domain-modeling
description: "Builds and sharpens a project's domain model by challenging terms, probing concrete scenarios, and writing the glossary as terms settle. Use when naming or defining a term, when a word is ambiguous or overloaded, when two people mean different things by the same word, or when asked to build the glossary or ubiquitous language, even when they only ask what we should call this. Not for data structures, types, or schemas, not for merely reading a glossary, and not for a full question-by-question interview."
---

# Domain Modeling

Actively build and sharpen the project's domain model during design. This is the *active* discipline: challenging terms, inventing edge-case scenarios, and writing the glossary down the moment a term crystallises. This skill is for changing the model, and a conflict found while reading hands over to it.

## File structure

A single-context repo keeps `docs/glossary.md`. A multi-context repo adds `docs/glossary-map.md`, which indexes one `docs/glossary/<context>.md` per context.

Create the file lazily, with the first resolved term.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `docs/glossary.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account': do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"

### Update the glossary inline

When a term is resolved, update `docs/glossary.md` (or `docs/glossary/<context>.md` in a multi-context repo) right there, one term at a time. Use the format in [GLOSSARY-FORMAT.md](references/GLOSSARY-FORMAT.md).

`docs/glossary.md` holds glossary entries only. Behavior belongs in tests and types.

### Record decisions in memory, not in ADRs

A decision that is hard to reverse, surprising without context, and the result of a real trade-off goes to a decision note with **memory**, anchored to the code it concerns. Write no new ADR. Leave existing ADRs where they are. When one states a rule that is still true, encode it as a test, a type, or a check, and the ADR can go.

When no one can answer, write your recommended meaning to the glossary marked `_Assumed_`, since what a business word means is the user's call and the mark lets them find and confirm it later.

Done when each term resolved in the session is in the glossary and each qualifying decision is saved, or none qualified.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
