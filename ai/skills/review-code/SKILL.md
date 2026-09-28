---
name: review-code
description: "Use when asked to review, check, or accept a diff, PR, or change. Runs an acceptance pass with adversarial review, breakage analysis, and comment cleanup, then returns a prioritized verdict."
---

# Review code

**Goal: decide whether a change is safe to accept against a stated goal. You are the acceptance reviewer, not the author. Inspect the actual artifact, never the reviewer's self-report.**

## Constraints

- Review the diff, PR, or change as written. Open it. Do not trust a summary of it.
- Apply only findings that affect the stated goal and carry evidence. A finding with no artifact behind it is not a finding.
- Report first, fix only on request.
- Give one-way-door changes more scrutiny than reversible ones.

## Acceptance rubric

State the rubric before reviewing. The change passes when every item holds:

- It does what the goal says, verified by running or reading the real result.
- It does not break behavior or callers the author did not account for.
- It leaves no comment or suppression that the code already says.
- Its failure modes are named, not hidden.

## Run

Run these as real invocations. Each does its own digging. Do not redo their work by hand.

1. **interrogate** for adversarial findings on the change.
2. **blast-radius** for what the change could break elsewhere, proved by running real code.
3. **no-comments** for comment and suppression cleanup.
4. **principle-prove-it-works** to verify the result against the actual artifact.

## Classify

Classify every finding as one of:

- **Act on**: affects the stated goal and has evidence. Fix or block.
- **Consider**: plausible, worth a decision, not blocking.
- **Noted**: true but out of scope for this change.
- **Dismissed**: no evidence, or does not affect the goal. Say why.

## Return

Return the rubric result, the classified findings, and the one thing most likely to bite.
