---
name: grill-with-docs
description: "Interviews the user on a design and writes glossary terms and ADRs as answers settle. Use when asked to grill with docs or when the interview must leave a written record."
---

# Grill with docs

Run the **grill** skill and the **domain-modeling** skill together. Writing a glossary entry or an ADR records a settled answer, so it is not the action the grill waits to act on: write each one as its decision settles, never batched at the end. Mention each ADR written in the next round so the user can veto it. When the user is unreachable, write each glossary entry or ADR, mark the ADR `proposed`, and list it in the hand-off.

Done when **grill** is done, every settled term is in the glossary, and every decision that passes the ADR tests has its ADR.
