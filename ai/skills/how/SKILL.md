---
name: how
description: "Traces a subsystem's call graph and data flow and returns a written trace. Use when asked to trace or map code or to answer where code lives. Trigger on trace this, map this, or where does this live. Not for teaching a learner."
---

# How

Build a working mental model from the repository. Do not infer behavior from
file names alone.

1. State the scope and the likely entry point.
2. Trace inputs, state, control flow, outputs, and side effects.
3. Read the definitions and callers needed to close the path.
4. Use independent subagents for seams with no shared
   call path. Explorers follow [explorer-prompt.md](references/explorer-prompt.md).
5. With explorer findings in hand, the explainer follows
   [explainer-prompt.md](references/explainer-prompt.md). A solo agent skips
   the explorer and writes to that prompt's Output Format directly. The answer
   opens with scope and entry point. Done when each claim in How It Works
   and Gotchas names a file or symbol.

Label inference per **why**. Do not prescribe a change unless the user asks for one.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
