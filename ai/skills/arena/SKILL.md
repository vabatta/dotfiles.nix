---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/arena/SKILL.md
name: arena
description: Compares competing solutions, selects a base, and verifies a synthesized result when one design would lock in the wrong shape.
---

# Arena

Use an arena for a design or implementation choice with several credible
solutions. Do not use it for a mechanical change.

1. Define the artifact and a three-to-six-point rubric.
2. Produce at least two structurally different candidates when the decision is
   architectural.
3. Give each writer the same brief and an isolated output location.
4. Read every candidate and score it against the rubric.
5. Select the base with the smallest, clearest public surface.
6. Graft only ideas that preserve one coherent design. Record rejected ideas.
7. Verify the synthesized artifact against the original definition of done.

The host chooses whether to delegate, which models to use, and how to schedule
workers. If delegation is unavailable, perform the candidates sequentially.

Return the candidates considered, the rubric scores, the selection, the grafts,
the rejected ideas, and the verification result.
