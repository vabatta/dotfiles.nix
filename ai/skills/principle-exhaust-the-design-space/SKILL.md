---
name: principle-exhaust-the-design-space
description: "Apply when a novel interaction or subsystem has no precedent in the codebase. Prototype two or three alternatives and compare before committing."
---

# Exhaust the Design Space

Explore several concrete alternatives before implementing a decision that has no established precedent.

**Why:** Building the wrong thing costs more than exploring three options, and a decision made without comparison locks in the first idea that came to mind.

**Pattern:**
- Sketch 2 to 3 alternatives when the codebase has no precedent, and compare them side by side before committing.
- Make the alternatives genuinely different shapes. A second flavor of the first shape does not count.

**Test:** At least two alternatives that differ in data model, control flow, or interface were each sketched (types or signatures plus one usage) or built, and a written comparison names the deciding criterion. One alternative, or three variants of one idea, fails.

For runnable throwaway evidence, use **prototype**.
