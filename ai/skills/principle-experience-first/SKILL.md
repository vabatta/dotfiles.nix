---
name: principle-experience-first
description: "Apply when product, UX, or feature-scope tradeoffs come up. Choose user delight over implementation convenience, and ship fewer polished features over more rough ones."
---

# Experience First

The product is the experience. When implementation convenience conflicts with user delight, choose delight.

**Why:** Features are easy to add and hard to remove, and polish is what survives contact with users. Implementation convenience is a local optimization.

**Pattern:**
- Make every feature, control, and option earn its place, and say no by default.
- Treat whoever consumes the work as the user. For a UI that is the end user, for a library or internal API the colleague who imports it, and the next maintainer is a user too. Name the consumer, then state the improvement from their entry point.

**Test:** Run the central workflow once from the consumer's entry point (the agent's own run counts when no human is present), then write one sentence naming the improvement that consumer sees. An improvement visible only to the implementer fails.
