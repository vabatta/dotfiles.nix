---
name: figure-it-out
description: "Designs an auditable phase plan with a hypothesis loop and a decision trail. Use when work spans multiple sessions or has a one-way door. Trigger on figure it out or long multi-session change. Not for a short task that fits one session."
---

# Figure it out

When the task fits no routine plan, design the plan. The deliverable before any code is the workflow itself: a sequence of phases that scales rigor to the task, runs the scientific method, and leaves a decision trail a human can audit after stepping away.

Don't over-build. A focused single-unit task routes to its own skill: **diagnosing-bugs** for a failure, **tdd** for a behaviour change, **plan-work** for a routine multi-step effort, **prototype** for a feasibility question. A large or cross-cutting version of one belongs here: work that spans more than one session, touches 10 or more sites, or contains a one-way door. The rigor and the audit trail are the point.

## Start

Record a task-list of one item per phase: A Frame, B Design, C Run (its unit steps are added under it in Phase B), D Audit, E Verify. Use the host's task tracking.

## Phase A: Frame

Ground first, then commit. Start the run only when the following can be stated:

- The definition of done as a falsifiable predicate, per **plan-work**. "Done well" has to be checkable.
- Any lesson in `.agent/INDEX.md` that touches this work, carried into the framing as a risk.
- Scope, quantified: rough units and effort, plus the blockers grounding surfaced. Raise them before spending hours, not after fifty doomed commits.
- The rigor level, one of three. Light: one check per unit. Standard: a hypothesis and a measured check per unit. Strict: standard plus an independent judge and a revert drill for one-way doors or high blast radius. Rigor is gates and artifacts, not "try harder".
- If this run resumes earlier work, reconstruct state and the next move per **recall** unless that already ran.
- The stack and the net-added-line budget, per the global rules.

Present the framing and tradeoffs as one checkpoint. When no one answers, record the recommended answer as an assumption and continue (**principle-never-block-on-the-human**). Done when the framing is written and the predicate is checkable.

## Phase B: Design the workflow

Decompose, sequence, and set the harness and baseline per **plan-work**. Scaffold and verification come before features (**principle-foundational-thinking**). Done when every unit in the plan has its check.

Before adding a dependency, helper, wrapper, or verification tool, apply
**principle-use-before-build**. Search the existing environment and repository
before creating new machinery.

- For one-way-door design decisions, run **architect** (which runs **arena**) and let **delegate** select models. Skip it for mechanical work whose shape is already concrete. A second arena over a settled design is over-engineering (**principle-laziness-protocol**).
- Decide what fans out, then fan out via the **delegate** skill. Parallelize only across genuine seams (**principle-separate-before-serializing-shared-state**). Don't over-fan.
- Write the phase list in **plan-work**'s plan file, each unit with its check. That list is what the human reviews.

Then put the design into motion. Add its steps to the task-list as concrete
items under the Phase C entry. Run each under the Phase C
loop discipline. Converge on the target
end state when designing each phase: define done by the outcome the task needs,
not by what the current intermediate state can reach, and delete throwaway
compatibility steps once the target shape lands (**principle-outcome-oriented-execution**).

## Phase C: Run the loop

Each unit is an experiment: state the hypothesis, make the smallest change, measure against the predicate on the real artifact, keep it if it advanced, revert it if it didn't.
Apply **principle-sequence-verifiable-units**, verifying each unit before starting the next instead of batching checks at the end.

- Verify per **principle-prove-it-works**. When something passes too easily, suspect the observation method before the system. A blank screenshot passes a lazy gate.
- Pair delegated work with a judge and audit the delegates' artifacts yourself before trusting them. If a worker games the gate, reset and harden the contract. If the gate itself is wrong, fix the gate in its own change rather than routing around it.
- A verdict is VERIFIED, NOT VERIFIED, or INCONCLUSIVE. Inconclusive is not a pass. Don't hide a negative.
- Keep bulk output out of the main thread (**principle-guard-agent-context**).

Done when every unit is landed and verified, or parked with its verdict.

## Phase D: Keep the audit trail

Log the run via **show-me-your-work**; it owns the format, where the trail lives, and its promotion rule. A figure-it-out run meets its ambitious-run definition, so run its audit, reviewer, and Attention section. Done when the trail has a row for each fork, unit, pivot, and blocker.

## Phase E: Verify and hand back

Check the whole against the Phase A predicate on the real product, not just the harness. Encode any recurring correction as a gate, a lint rule, a check, or a script, so the win can't silently regress (**principle-encode-lessons-in-structure**).

**Reply:** the plan you designed, the rigor level and why, the decision-trail path, what's verified against the predicate, and what's still open, then the Attention section from **show-me-your-work**. Done when the Reply names each of those.
