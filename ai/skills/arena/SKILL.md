---
name: arena
description: "Builds competing candidate artifacts in isolation, scores them against a rubric, and synthesizes one result. Use when asked to implement or draft several versions and pick the best, not for one design to build or a feel test. Trigger on bake-off, score the options, or compare candidate implementations."
---

# Arena

1. Define the artifact, its definition of done, and a three-to-six-point rubric.
   Done when all three are written.
2. Produce at least two structurally different candidates. Use this when the design has no precedent in the codebase.
3. Fan the writers out as subagents, one per candidate, each on its own branch
   `arena/<slug>/N` in its own checkout, so no two writers share a file. Use the
   harness's isolated checkout where it has one, otherwise `git worktree add`.
4. Read every candidate and score it against the rubric.
5. Select the base by rubric score. Break ties by the rubric's first axis.
6. Graft only ideas that preserve one coherent design. Record rejected ideas.
7. Verify the synthesized artifact against the original definition of done.
8. Fold the verdict into real code, unless the caller asked only for the
   selected artifact. Save the verdict and the rejected ideas as a decision with **memory**
   (`--topic` `arena/<slug>`), then delete the candidate
   branches and worktrees. They are working state.

Reply in the shape of [assets/report.md](assets/report.md): the selection and
verification first, then the score, graft, and rejected-idea tables.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
