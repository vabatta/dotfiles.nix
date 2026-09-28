---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/principle-redesign-from-first-principles/SKILL.md
name: principle-redesign-from-first-principles
description: "Apply when integrating a new requirement into an existing design. Redesign as if the requirement had been a foundational assumption from day one, instead of bolting it on."
---

# Redesign From First Principles

When integrating a change, don't bolt it onto the existing design. Redesign as if the requirement had been there from the start. The result should look like what we would have built if we'd known on day one.

**Why:** Bolting on preserves the old shape and leaves the new requirement as an exception. Redesigning from first principles keeps option value and removes the seams a bolt-on would hide.

- Read all affected files and understand the current design holistically
- Ask: "if we were writing this from scratch with this new requirement, what would we build?"
- Propagate the change through every reference: types, docs, examples, rationale sections
- Think about the redesign holistically, then deliver it incrementally

This is the method for preserving option value when integrating changes into an existing design.

**Test:** The result reads as if the requirement was always present. A new special case, fork, or "handled separately" comment marks a bolt-on that skipped the redesign.
