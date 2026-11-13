---
name: investigate
description: "Examines the current state of a system against a broad quality goal and returns ranked, evidenced findings with candidate fixes, without building anything. Use when asked can we improve, where are we weak, why is this unreliable or flaky, or to audit a quality such as determinism, reliability, speed, or clarity. Trigger on investigate, audit, find weak spots, or can we improve. Not for judging one named change and not for one concrete bug."
---

# Investigate

An open question about quality, answered with evidence from the system as it is. The output is a ranked list of findings and candidate fixes. Nothing is built and no file is written.

Use this when no change is on the table yet. When you can state a specific change as "replace X with Y", use **assess**.

## Frame

Restate the goal as an observable symptom. "Improve determinism" becomes "the same input gives a different result, and this is how we would see it." Name the scope: which code, skills, runs, or period. Done when the symptom, the observation that would show it, and the scope are written. When the missing context lives with the user and they cannot answer, state the reading you chose as an assumption and continue.

## Pick the goal's variant

Read only the variant that matches the goal. It names what to measure, how, where to look first, and what makes a finding PROVEN. A goal that matches none uses the general method below.

| Variant | Pick when |
|---|---|
| [reliability](references/goals/reliability.md) | It should fail less or recover by itself |
| [speed](references/goals/speed.md) | It should run faster: latency, throughput, build or test time |
| [determinism](references/goals/determinism.md) | The same input should give the same result |
| [clarity](references/goals/clarity.md) | The code should be easier to read and change |
| [security](references/goals/security.md) | Less should go wrong if someone tries |
| [cost](references/goals/cost.md) | It should cost less: money, tokens, compute, CI minutes |

## Collect evidence

Evidence comes from artifacts, not opinion. Start from the variant's measures when one applies.

- Real runs: rerun the thing several times and diff the results, or read past logs, transcripts, and failures.
- The record: Engram (`mem_search` for decisions, reverted or failed attempts, and learnings in this area) and the git history.
- The structure: where a rule exists only as prose, and where a script or check could hold it instead.

Fan out one read-only subagent per seam when the scope has several. Route bulk output to the subagents and keep summaries. Done when each finding has a pointer a reader can open, such as a `file:line`, a command and its output, or a run count.

## Rank

For each finding write the symptom, the cause, how often it happens, and what it costs. Ground the cause with **how** or **why** when it is not obvious. Mark a finding PROVEN when you reproduced or measured it and CLAIM when you only read about it. Order by cost times frequency. Done when every finding carries PROVEN or CLAIM and an order.

## Candidates

For the top findings give one candidate fix each. Prefer a structural fix (a script, a check, a gate, a deleted step) over more prose. Write the candidate as a claim that **assess** could judge, and do not build it. Done when each top finding has a candidate or a stated reason it has none.

## Hand off

Reply in the shape of [assets/findings.md](assets/findings.md), and save it with `mem_save` (`topic_key` `investigate/<slug>`). The next move per finding:

- A candidate worth judging goes to **assess**.
- A candidate that is obviously right and small goes to **build**.
- A finding that is one concrete bug goes to **diagnosing-bugs**.

Done when the reply follows the template, every finding has a status and a next move, and the record is saved.
