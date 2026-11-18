# Global agent principles

These rules apply in every session:
- Before code, state the stack (load build).
- Verify the real artifact before declaring done (load build).
- On reversible work, decide and proceed (load build).
- For a vague or open goal, load figure-it-out.

The code is the source of truth. Behavior lives in test names and types. Write no plan, ADR, or note that restates code. Treat a memory as a hint and check its refs against the code. When the same lesson comes up twice, encode it as a check (a test, lint rule, or script).
