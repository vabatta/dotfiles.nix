---
name: assess
description: "Evaluates a proposed change, or weighs the options for an open question, through independent lenses and returns one verdict with evidence, covering whether it makes sense, what it buys, how big it is, and whether it is feasible. Use when deciding whether to make a change or which way to go, not how to make it or to prove it by building. Trigger on does this make sense, should we do this, is it worth it, how big a change, is this feasible, which option, roundtable, panel, or get perspectives."
---

# Assess

One question, one verdict, with the evidence, the size, and the strongest dissent.

The question takes one of two shapes:

- **Proposal.** One change is on the table: "replace X with Y". The verdict is do, don't, or conditional.
- **Open question.** Two or more ways to go, or none named yet: "how should we handle X?". The verdict picks one option, or makes it conditional.

When the question is a broad quality goal with nothing to choose between ("where are we weak?"), use **investigate** first and bring its candidates here.

## Frame

For a proposal, state it as a falsifiable claim: "Replacing X with Y improves A without costing B." For an open question, list two to four options, each as such a claim. When none are named, the first lens round proposes them. Name the decision criteria: what would make an option worth doing, and what would kill it. Done when each claim and the kill criterion are written.

When the claim or criteria are vague and the missing context lives with the user, run **grill** first. For what the codebase holds use **how** and **why**, and **to-questionnaire** when the knowledge sits with a third person. When the user cannot be reached, state the claims and criteria as assumptions and continue.

## Ground the current system

Reuse any findings already supplied, and scale the steps to the size. With no existing code (greenfield), skip this section and state "greenfield" as the grounding. For a question touching fewer than five call sites, ground and prove the facts directly and run one dissent lens instead of a full panel.

Run **how** over the affected subsystem. Run **why** when the current shape is what the question challenges. Grep the callers and seams a change would touch. Done when you can state how the current system works, why it has its shape, and who depends on it.

## Find the load-bearing facts

Name the two or three facts the verdict hinges on. A fact is load-bearing when the verdict flips if it changes. Prove each by running it, reading the source, or checking history, or mark it unproven. Run **prototype** only when nothing else can answer. Done when each fact is marked proven or unproven.

## Get independent lenses

Pick three to five lenses from the roster in [references/lenses.md](references/lenses.md), always including the dissent lens. Brief each one with that file's brief, filled in, and run them in parallel as subagents. Lenses do not see each other's answers in the first round.

For an open question with no options yet, run one round where each lens proposes its best option, merge duplicates down to two to four, then run the judging round on those. A material disagreement that survives is a finding the verdict carries, not one to smooth over. Done when every lens has answered on every option.

## Weigh

Judge each option on four axes:

- **Benefit.** What it buys against a problem actually observed, not a hypothetical one.
- **Loss.** What it costs: flexibility, reach, new constraints. Name what the current looseness provides.
- **Size.** Call sites, modules, invariants, data or migrations. Rough units, not hours.
- **Reversibility.** Can it be built with what exists, and is the door one-way or two-way?

When the target design itself is open, run **arena** for competing designs. That is separate from the lenses, which judge the options as stated.

## Verdict and reply

Reply in the shape of [assets/verdict.md](assets/verdict.md): the verdict line first, then the tables. Give confidence as high, medium, or low, and the one fact that would most change the verdict. Keep prose to the sentences the tables cannot hold.

Save the claim, the kill criterion, the proven facts, the lens disagreements, and the verdict with `mem_save` (`topic_key` `assess/<slug>`) when the decision is hard to reverse. Use the slug of the `investigate` record when the question came from one.

## Next

- Do → build it with **build**, and shape it first with **architect** only when it adds a new module or interface.
- Conditional → run the smallest probe that settles the condition, or **prototype** only when code must be built.
- Don't → stop, and state what would change the answer.

Done when every load-bearing fact is marked proven or unproven, every lens has answered, and the reply follows the verdict template.
