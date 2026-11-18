---
name: arena
description: "Builds competing candidate artifacts in isolation, pushing each writer toward a different stance for real diversity, scores them against a rubric, and synthesizes one result for the caller to use. Covers code designs, code implementations, and general ideas. Use when asked for several versions, options, or approaches to pick the best from, not for one design to build or a feel test. Trigger on bake-off, score the options, compare candidate implementations, give me options, or brainstorm competing ideas."
---

# Arena

Wide exploration with a judge. Arena produces and selects. It never ships: the caller takes the selected artifact into **architect**, **build**, or the reply.

## Pick the variant

Read only the chosen variant. It sets what a candidate is, where it lives, the default rubric, and how to verify.

| Variant | Pick when |
|---|---|
| [code-design](references/variants/code-design.md) | Competing shapes: types, signatures, module maps |
| [code-implementation](references/variants/code-implementation.md) | Competing working code behind one fixed interface |
| [ideas](references/variants/ideas.md) | Competing approaches, plans, product ideas, names, or formats, in prose or mock form |

Done when the variant is named.

## Steps

1. Define the artifact, its definition of done, and a three-to-six-point rubric, starting from the variant's default. Done when all three are written.
2. Assign each writer a different stance from [references/stances.md](references/stances.md), at least two writers and usually three. A stance is a push, not a costume: it decides what the writer optimises and what it is allowed to ignore. Done when no two writers share a stance.
3. Fan the writers out as subagents, one per candidate, each in its own location as the variant says, so no two writers share a file. With no subagents, write the candidates one after another, and finish each before reading the next. Brief each writer: produce the best artifact you can from your stance, do not hedge toward the others, a safe middle defeats the exercise.
4. Read every candidate and score it against the rubric. Done when every cell of the score table is filled.
5. Select the base by rubric score, so the choice can be checked rather than argued. Break ties by the rubric's first axis, since you listed it first because it matters most.
6. Graft only ideas that keep one coherent design, because a patchwork of best parts usually breaks the invariants each part relied on. Record rejected ideas with the reason, so the next run does not try them again.
7. Verify the synthesized artifact against the definition of done, using the variant's check. Done when the check's result is quoted.
8. Save the verdict and the rejected ideas as a decision with **memory** (`--topic` `arena/<slug>`). Return the selected artifact to the caller, as the variant says. When the user invoked arena directly and asked for working code, hand the synthesized branch to **build** to take into production code. Then delete the other candidates' branches, worktrees, and folders. They are working state.

Reply in the shape of [assets/report.md](assets/report.md): the selection and verification first, then the score, graft, and rejected-idea tables.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
