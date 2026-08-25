---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/how/SKILL.md
name: how
description: Explains how a subsystem works, traces runtime flow, and answers placement or ownership questions before a change.
---

# How

Build a working mental model from the repository. Do not infer behavior from
file names alone.

1. State the scope and the likely entry point.
2. Trace inputs, state, control flow, outputs, and side effects.
3. Read the definitions and callers needed to close the path.
4. Use independent explorers for genuinely separate seams when the host can
   delegate. Otherwise explore sequentially.
5. Explain the result with an overview, key concepts, flow, file map, and
   gotchas.

Reference concrete files and symbols. Distinguish observed behavior from
inference. Do not prescribe a change unless the user asks for one.
