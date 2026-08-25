---
source: https://github.com/vabatta/dotfiles.nix/blob/main/ai/skills/team-discussion/SKILL.md
name: team-discussion
description: Runs a structured discussion with multiple agents for decisions, tradeoffs, architecture questions, and difficult investigations. Use when the user asks to discuss something with a team, panel, roundtable, or multiple perspectives.
---

# Team Discussion

Use a team discussion when the value comes from distinct viewpoints examining
the same question. The coordinator owns the question, the rounds, and the
final synthesis. The participants provide evidence and judgment. They do not
edit the repository.

## Choose The Shape

Use this skill for a decision or investigation that benefits from disagreement.

- Use `swarm` when workers can complete independent slices without discussion.
- Use `arena` when the output is several competing artifacts that need scoring.
- Use `interrogate` when an existing change needs adversarial review.
- Use `how` or `why` when one explanation or evidence search is enough.

## Discussion Protocol

### 1. Frame

State the question, the decision or artifact it should produce, the constraints,
and what evidence would change the conclusion. Separate facts already known from
claims the participants must investigate.

### 2. Assign Lenses

Choose three to five distinct roles based on the question. Useful lenses include
user impact, implementation design, operations, security, testing, maintenance,
and deliberate dissent. Give every participant the same grounding and a
specific responsibility. Do not assign roles by model name.

### 3. First Round

Run the participants independently before showing them other responses. Each
returns:

- Position and confidence.
- Evidence, with file paths, measurements, or source links.
- Important assumptions.
- Risks and counterexamples.
- The condition that would change the position.

Use the host's delegation capability when available. Keep participants
read-only unless the discussion explicitly requires a separate prototype.

### 4. Synthesize

The coordinator groups the responses into agreements, disagreements, unknowns,
and evidence gaps. Do not average opinions. Distinguish agreement supported by
evidence from agreement caused by identical assumptions.

### 5. Challenge

Run a second round only on material disagreements or unsupported assumptions.
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

Inspect the actual participant outputs. Treat their reports as evidence to
check, not as proof. If delegation is unavailable, run the lenses sequentially
and keep the same output contract.
