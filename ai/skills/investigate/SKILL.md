---
name: investigate
description: "Examines the current state of a system against a broad quality goal and returns ranked, evidenced findings with candidate fixes, without building anything. Use when asked can we improve, where are we weak, why is this unreliable or flaky, or to audit a quality such as determinism, reliability, speed, or clarity. Trigger on investigate, audit, find weak spots, or can we improve. Not for judging one named change and not for one concrete bug."
---

# Investigate

An open question about quality, answered with evidence from the system as it is. The output is a ranked list of findings and candidate fixes. Nothing is built, and the only file written is the findings file, plus any delegate briefs.

Use this when no change is on the table yet. When you can state a specific change as "replace X with Y", use **assess**.

## Frame

Restate the goal as an observable symptom. "Improve determinism" becomes "the same input gives a different result, and this is how we would see it." Name the scope: which code, skills, runs, or period. Done when the symptom, the observation that would show it, and the scope are written. When the missing context lives with the user and they cannot answer, state the reading you chose as an assumption and continue (**principle-never-block-on-the-human**).

## Collect evidence

Evidence comes from artifacts, not opinion.

- Real runs: rerun the thing several times and diff the results, or read past logs, transcripts, and failures.
- The record: `.agent/INDEX.md` lessons, `.agent/decisions/` rows marked reverted, failed, or INCONCLUSIVE, and `.agent/handoffs/`.
- The structure: where a rule exists only as prose, and where a script or check could hold it instead.

Fan out one read-only worker per seam per **delegate** when the scope has several. Route bulk output to the workers and keep summaries (**principle-guard-agent-context**). Done when each finding has a pointer a reader can open, such as a `file:line`, a command and its output, or a run count.

## Rank

For each finding write the symptom, the cause, how often it happens, and what it costs. Ground the cause with **how** or **why** when it is not obvious. Mark a finding PROVEN when you reproduced or measured it and CLAIM when you only read about it. Order by cost times frequency. Done when every finding carries PROVEN or CLAIM and an order.

## Candidates

For the top findings give one candidate fix each. Prefer a structural fix (a script, a check, a gate, a deleted step) over more prose (**principle-encode-lessons-in-structure**, **principle-subtract-before-you-add**). Write the candidate as a claim that **assess** could judge, and do not build it. Done when each top finding has a candidate or a stated reason it has none.

## Hand off

Write `.agent/runs/investigate/<slug>.md` with the symptom, the findings table, the candidates, and what could not be measured. Name the next move per finding:

- A candidate worth judging goes to **assess**.
- A candidate that is obviously right and small goes to **plan-work**.
- A finding that is one concrete bug goes to **diagnosing-bugs**.

**Reply:** the goal as a symptom, the findings ranked with PROVEN or CLAIM, what could not be measured, the candidates, and the next move per finding. Done when the reply names each and the findings file exists.
