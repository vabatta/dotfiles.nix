---
name: team-discussion
description: "Runs independent lenses on one question and returns one evidenced recommendation, surfacing where perspectives disagree. Use when one question needs several viewpoints, such as a roundtable or panel. Trigger on roundtable, panel, get perspectives, or what do others think. Not for splitting work into slices."
---

# Team Discussion

Use a team discussion when the value comes from distinct viewpoints examining
the same question. The coordinator owns the question, the rounds, and the
final synthesis. The participants provide evidence and judgment.

## Choose The Shape

- Use **delegate** when workers can complete independent slices without discussion.
- Use **arena** when the output is several competing artifacts that need scoring.
- Use **adversarial-review** when an existing change needs adversarial findings.
- Use **how** or **why** when one explanation or evidence search is enough.

## Discussion Protocol

### 1. Frame

State the question, the decision or artifact it should produce, the constraints,
and what evidence would change the conclusion. Separate facts already known from
claims the participants must investigate.

### 2. Assign Lenses

Choose three to five distinct roles based on the question. Useful lenses include
user impact, implementation design, operations, security, testing, maintenance,
and deliberate dissent. Brief each participant per **delegate** as a read-only `judgment` worker.

### 3. First Round

Run the participants independently before showing them other responses. When the host cannot delegate, use **delegate**'s sequential fallback and state in the output that independence was simulated. Each
returns:

- Position and confidence.
- Evidence, with file paths, measurements, or source links.
- Important assumptions.
- Risks and counterexamples.
- The condition that would change the position.

### 4. Synthesize

The coordinator groups the responses into agreements, disagreements, unknowns,
and evidence gaps. Do not average opinions. Distinguish agreement supported by
evidence from agreement caused by identical assumptions.

### 5. Challenge

Run one challenge round, only on disagreements that would change the recommendation.
Give each participant the opposing claims and ask for a rebuttal, an update to
confidence, or an explicit concession. Do not restart the whole discussion.

### 6. Decide

The coordinator produces the recommendation. A useful conclusion may be no
decision when a missing fact is genuinely blocking. Name the evidence needed to
resolve it and the smallest next investigation.

## Output Contract

Return:

- The question and decision criteria.
- The participating lenses.
- Agreements and their evidence.
- Disagreements and the strongest arguments on each side.
- Assumptions and unresolved evidence gaps.
- The recommendation and confidence.
- The next action or the reason no decision is ready.

**Test:** the coordinator re-read or re-ran every cited path and number, and the output has every contract item.
