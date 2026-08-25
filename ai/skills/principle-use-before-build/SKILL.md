---
source: https://github.com/vabatta/dotfiles.nix/blob/main/ai/skills/principle-use-before-build/SKILL.md
name: principle-use-before-build
description: "Apply before writing custom code, wrappers, or helpers. Check the language standard library, installed dependencies, and existing project APIs first. Inspect the real API and use the smallest appropriate integration before building a replacement."
---

# Use Before Build

Before writing new code, look for code that already solves the problem. The
language standard library, an installed dependency, and an existing project
API are part of the system you are working in. Use them before adding another
implementation.

**Why:** Every custom implementation creates ownership. A wrapper creates a
second interface to keep aligned. An existing dependency already carries tested
behavior, edge-case handling, documentation, and upgrade history. Reusing it
keeps the change smaller and makes future maintenance someone else's solved
problem where that is appropriate.

**Pattern:**

- Search package manifests, lockfiles, imports, the standard library, and
  existing call sites before proposing a new dependency or implementation.
- Inspect the installed version's public API, types, documentation, and source
  when the usage is unclear. Delegate the search when the dependency is large,
  but inspect the evidence yourself.
- Prefer the project's existing integration pattern over a new wrapper. Use
  the public API and preserve the dependency's intended data flow.
- Write the smallest probe or test that proves the dependency handles the real
  case before building on it.
- Add an adapter only when a real boundary needs translation, ownership, or
  policy. Keep it at that boundary instead of mirroring the dependency's API.
- If the installed version cannot support the requirement, record the missing
  capability and then choose between an upgrade, a narrower integration, or a
  new implementation.

**Balance:** Do not force an ill-fitting dependency into the design. A small,
clear implementation is better than a large dependency used for one trivial
operation. The point is to check reuse first, not to avoid all new code.

Distinct from [Laziness Protocol](../principle-laziness-protocol/SKILL.md),
which minimizes the shape of the change, and [Build the Lever](../principle-build-the-lever/SKILL.md),
which builds a reusable tool when custom work is justified. For validation at
the integration boundary, see [Boundary Discipline](../principle-boundary-discipline/SKILL.md).
