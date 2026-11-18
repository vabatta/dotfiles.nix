---
name: why
description: "Searches history, ADRs, and sources for the motive behind a design choice, threshold, or past decision, separating facts from inference. Use when asked why did we choose X or what the recorded reasoning was."
---

# Why

Use why when the motivation or history matters. Read [epistemics.md](references/epistemics.md) first for the confidence tiers and calibrated phrasing, since every claim gets one. Start with the code and Git
history. Search issues, documents, conversations, observability, error reports,
or analytics only when the host provides those sources.

1. State the target and the interpretation of the question.
2. Search source-control history, commits, tests, and code comments. With no PR or `gh`, use `git log` and `git diff` alone.
3. Search each available external source independently.
4. Record empty or unavailable sources as explicit gaps.
5. Cite every claim about intent. Label each claim with its tier from the epistemics reference (Direct, Supported, Inferred, Speculative, or Unknown). For
   defensive-looking code (null checks, retries, timeouts, rate limits, feature
   flags), search incident and postmortem history when available. Before
   returning, spot-check that each cited source says what the claim says and
   surface contradictions between sources.
6. Reply in the shape of [assets/answer.md](assets/answer.md). Add its
   Preserve, Change, Avoid, Risk block only when the answer will guide
   implementation. Done when every intent claim carries a tier label, and a
   citation unless the tier is Unknown.

Read
[code-archaeology.md](references/code-archaeology.md) for the git and `gh`
queries behind step 2.

When the missing knowledge lives with another person, use **to-questionnaire**.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
