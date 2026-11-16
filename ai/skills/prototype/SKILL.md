---
name: prototype
description: "Builds a throwaway prototype to answer one question, logic, UI, or feasibility, and captures the answer. Use to sanity-check whether a state model feels right, to explore what a UI should look like, or to prove a proof of concept or spike works, not for scoring finished candidates. Trigger on prototype, mock it up, proof of concept, POC, or spike."
---

# Prototype

A prototype is throwaway code that answers a question. The question decides the shape.

## Pick a branch

Read only the chosen variant.

| Variant | Pick when |
|---|---|
| [logic](references/LOGIC.md) | Does this logic or state model feel right? |
| [UI](references/UI.md) | What should this look like? |
| [feasibility](references/FEASIBILITY.md) | Can we even do this? Does an approach, library, API, or integration work at all? |

If the branch is ambiguous and the user is unreachable, choose from the surrounding code: a backend means logic, a page or component means UI, a viability question means feasibility. State the assumption at the top.

## Rules for all branches

1. Throwaway from day one and clearly marked. A logic or feasibility prototype lives in `.agents/prototypes/<slug>/`; a UI prototype has to run in its real context, so scaffold it in the app following existing routing.
2. Trivial to run, one task-runner command or a double-click HTML file.
3. No persistence by default. If persistence is the question, use a scratch file named to be wiped.
4. Skip polish, tests, and abstractions. A feasibility prototype may pull real dependencies, but it still skips tests and refactoring.
5. Surface the full relevant state after every action or variant switch.
6. Capture when done. Done when all of these hold:
   - The verdict is saved in the shape of [assets/verdict.md](assets/verdict.md).
   - A UI prototype is kept on a throwaway branch off main. A logic or feasibility prototype stays in `.agents/prototypes/<slug>/` and is deleted once the verdict is saved.
   - A context pointer is on the issue, only if one exists.
   - Nothing is folded into real code. The prototype is evidence, not the implementation.

This is evidence you feel or measure, not scored candidates. For two to three architectural candidates compared against a rubric, use **arena**.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
