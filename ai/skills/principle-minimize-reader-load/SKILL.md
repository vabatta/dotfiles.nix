---
name: principle-minimize-reader-load
description: "Apply when shaping or reviewing code with many indirections or hidden state, or when a task bans indirection or wrapping code. Collapse one-caller wrappers and shrink mutable scope."
---

# Minimize Reader Load

Minimize the work a reader must do to understand code, along two independent axes: layers to trace between a question and its answer, and hidden or mutable state to hold in mind.

**Why:** Reader load, not LOC or cyclomatic complexity, is what matters. A flat file with 50 globals can be as hard to reason about as a 6-layer adapter stack.

**Pattern:**
- **Collapse layers** that do not earn their keep, such as wrappers with one caller, adapters with no second implementation, and indirection for a future that never came. Inline them in code the change already touches, and name the rest in the final report. A wrapper is a function, class, or module whose body only forwards its arguments to one call.
- **Shrink state scope:** pure functions over mutations, locals over fields, fields over module state, module state over globals. Derive instead of sync.
- Add a layer or a piece of state only if the Test passes.

## Shape limits

A shape limit from the task, such as no indirection or no wrapping code, or from `Constraints` in the repo's `AGENTS.md`, is binding. Breaches follow **principle-laziness-protocol**.

**Test:** Count the callers of every new function, class, and module with grep. Each has two or more callers or sits at a named boundary (I/O, an external API, or a seam that needs translation, ownership, or policy). A new symbol with one caller and no boundary is inlined. Then grep for the definition and every assignment of each touched piece of state, and expect at most 3 hops from question to answer.
