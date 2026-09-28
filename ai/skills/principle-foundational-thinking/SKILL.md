---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/principle-foundational-thinking/SKILL.md
name: principle-foundational-thinking
description: Apply before writing logic, when choosing core types and data structures, sequencing scaffold-versus-feature work, or deciding what concurrent actors share. Get the data structures right so downstream code becomes obvious.
---

# Foundational Thinking

Get the core data structures right before writing logic, and sequence work for option value.

**Why:** **Structural decisions** protect option value; **code-level decisions** protect simplicity. Over-engineering is often a premature decision that closes doors. The right foundational data structure keeps doors open.

**Pattern:**

- **Data structures first.** Get the data shape right before writing logic. The right shape makes downstream code obvious. Define core types early, trace every access pattern, and choose structures that match the dominant paths. A data-structure change late is a rewrite; early, it is often a one-line diff.
- DRY the structure, not every line. Types and data models should converge. Three similar statements still beat a premature abstraction. Prefer explicit over clever. Test behavior and edge cases, not line counts.
- **Concurrency corollary:** if two actors might touch the same mutable state, eliminate the sharing first. See **principle-separate-before-serializing-shared-state**.
- **Scaffold first.** If something helps every later phase, do it first. Ask "does every subsequent phase benefit from this existing?" CI, linting, test infrastructure, and shared types are scaffold. Sequence for option value: setup before features, tests before fixes. Keep commits small and single-purpose.
- Each increment should land a coherent abstraction or deepen one that exists. Do not spread a new capability across callers as special-case coordination.
- Subtraction comes before scaffolding: remove dead weight first, then lay foundations. See **principle-subtract-before-you-add**.

**Test:** Can a new engineer trace each dominant access path through the named core types without a rewrite? If the data shape is still being discovered mid-feature, the foundation was skipped.
