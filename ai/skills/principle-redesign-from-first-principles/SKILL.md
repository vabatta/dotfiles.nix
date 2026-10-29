---
name: principle-redesign-from-first-principles
description: "Apply when adding a requirement to an existing design. Reshape it as if the requirement were foundational, instead of bolting it on."
---

# Redesign From First Principles

Integrate a change by redesigning as if the requirement had been there from the start.

**Why:** Bolting on preserves the old shape and leaves the new requirement as an exception. Redesigning keeps option value and removes the seams a bolt-on would hide.

**Pattern:**
- Read all affected files and understand the current design holistically.
- Ask what would be built from scratch with this requirement, and build that. A budget the user states binds over the redesign. With only an estimate, the redesign wins and the estimate is restated.
- Propagate the change through every reference: types, docs, examples, rationale sections. Grep for the old term and the old rule's wording, and note any behavior change the redesign introduces.
- Land a redesign that touches more than one module as units that each pass a check, per **principle-sequence-verifiable-units**. A breach of the budget is reported per **principle-laziness-protocol**.

**Test:** No new branch, fork, or "handled separately" comment exists solely for the new requirement, and grep finds no doc still describing the old rule. The result then reads as if the requirement was always present.
