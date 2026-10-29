---
name: assess
description: "Evaluates a proposed change before committing to it and returns a verdict with evidence, covering whether it makes sense, what it buys, how big it is, and whether it is feasible. Use when deciding whether to make a change, not how to make it or to prove it by building. Trigger on does this make sense, should we do this, is it worth it, how big a change, or is this feasible."
---

# Assess

One proposal, one verdict: do, don't, or conditional, with the evidence, the size, and the strongest dissent.

Use this when a specific change is on the table. If you cannot state it as "replace X with Y", use **investigate** first and bring its candidates here one at a time.

## Frame

State the proposal as a falsifiable claim: "Replacing X with Y improves A without costing B." Name the decision criteria: what would make it worth doing, and what would kill it. Done when the claim and the kill criterion are written.

When the claim or criteria are vague and the missing context lives with the user, run **grill** first. For what the codebase holds use **how** and **why**, and **to-questionnaire** when the knowledge sits with a third person. When the claim is crisp or the user cannot be reached, state the claim and criteria as assumptions and continue.

## Ground the current system

Reuse any findings already supplied, and scale the steps to the size. With no existing code (greenfield), skip this section and state "greenfield" as the grounding. For a question touching fewer than five call sites, ground and prove the facts directly and run one dissent lens instead of a full discussion.

Build the model of what exists before judging the change. Run **how** over the affected subsystem. Run **why** when the current shape is what the proposal questions: the sense of replacing something depends on why it was built that way. Grep the callers and seams the change would touch.

Done when you can state how the current system works, why it has its shape, and who depends on it.

## Find the load-bearing facts

Name the two or three facts the verdict hinges on. A fact is load-bearing when the verdict flips if it changes.

Prove each fact per the **blast-radius** ladder or mark it unproven. Run **prototype** only when nothing else can answer.

## Get independent lenses

Run **team-discussion** on the framed claim, the criteria, the grounding, and the proven facts. Include one deliberate dissent lens.

A material disagreement that survives the discussion is a finding the verdict must carry, not smooth over.

## Weigh

- **Benefit.** What it buys against a problem actually observed, not a hypothetical one.
- **Loss.** What it costs: flexibility, reach, new constraints. Name what the current looseness actually provides.
- **Size.** Scope: call sites, modules, invariants, data or migrations. Rough units, not hours.
- **Feasibility and reversibility.** Can it be built with what exists, and is the door one-way or two-way?

When the target design itself is open, run **arena** for competing target designs. That is separate from the lenses, which judge the proposal as stated.

## Verdict

Return one of:

- **Do.** With the reason, the size, and the dissent that remains.
- **Don't.** With the fact that kills it.
- **Conditional.** Do it only if X; or try the smaller variant Y first. Name the condition.

Always give confidence and the one fact that would most change the verdict. Give confidence as high, medium, or low.

Write the claim, the kill criterion, the proven facts, the lens disagreements, and the verdict to `.agent/runs/assess/<slug>.md` unless the reply is the whole record. Use the slug of the `investigate` file when the claim came from one.

## Next

- Do → sequence it with **plan-work**, and shape it first with **architect** only when it adds a new module or interface; record the decision as an ADR via **domain-modeling** when it is hard to reverse.
- Conditional → run the smallest probe that settles the condition, a one-off command, or **prototype** only when code must be built.
- Don't → stop, and state what would change the answer.

Done when every load-bearing fact is marked proven or unproven, the verdict carries confidence and the one fact that would change it, and the verdict file exists or the reply is the whole record.

**Reply:** the claim, the load-bearing facts with proof, the lens agreements and disagreements, the four-axis weigh, the verdict with confidence, and the next action.
