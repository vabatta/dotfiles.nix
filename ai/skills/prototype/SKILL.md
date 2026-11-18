---
name: prototype
description: "Builds a throwaway prototype to answer one question about a code design, a code implementation, or an idea, and captures the answer. Use to sanity-check whether a state model or interface feels right, to prove an approach, library, or integration works, or to feel out a UI, CLI flow, or format, not for scoring finished candidates. Trigger on prototype, mock it up, try it out, proof of concept, POC, or spike."
---

# Prototype

A prototype is throwaway code that answers a question. The question decides the shape.

## Pick a variant

Read only the chosen variant.

| Variant | Pick when |
|---|---|
| [code-design](references/variants/code-design.md) | Does this shape feel right in use? A state model, data shape, or interface |
| [code-implementation](references/variants/code-implementation.md) | Does this approach work at all? A library, API, integration, or algorithm |
| [ideas](references/variants/ideas.md) | What should this be like? A UI, CLI flow, format, or template to look at or use |

If the variant is ambiguous and the user is unreachable, choose from the question: a shape to use means code-design, a yes-or-no on viability means code-implementation, something to look at means ideas. State the assumption at the top.

## Rules for all variants

1. Throwaway from day one and clearly marked. A prototype lives in `.agents/prototypes/<slug>/`, except a UI, which has to run in its real context, so scaffold it in the app following existing routing.
2. Trivial to run, one task-runner command or a double-click HTML file, because the person judging it will not set anything up.
3. No persistence by default, since stored state outlives the question and gets mistaken for a real feature. If persistence is the question, use a scratch file named to be wiped.
4. Skip polish, tests, and abstractions, because the code is deleted once the question is answered and every hour on it is an hour not spent on the answer. A code-implementation prototype may pull real dependencies, but it still skips tests and refactoring.
5. Surface the full relevant state after every action or variant switch, so the judge sees what changed instead of guessing.
6. Capture when done. Done when all of these hold:
   - The verdict is saved in the shape of [assets/verdict.md](assets/verdict.md).
   - A UI prototype is kept on a throwaway branch off main. Any other prototype stays in `.agents/prototypes/<slug>/` and is deleted once the verdict is saved.
   - A context pointer is on the issue, only if one exists.
   - Nothing is folded into real code. The prototype is evidence, not the implementation.

This is evidence you feel or measure, not scored candidates. For candidates scored side by side against a rubric, use **arena**.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
