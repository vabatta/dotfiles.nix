# Cost

**Pick when:** the goal is that it costs less to run: money, tokens, compute, CI minutes, agent calls.

## What to measure
- Cost per run or per unit of work, at today's volume and at ten times.
- The share of cost that buys nothing: retries, repeated work, bookkeeping calls, idle resources.
- The largest single line: which job, model, call, or resource dominates.

## How to measure
- CI minutes: `gh run list --limit 100 --json name,createdAt,updatedAt | jq -r 'group_by(.name)[] | "\(.[0].name) \(map((.updatedAt | fromdate) - (.createdAt | fromdate)) | add)s"'` sums the seconds per workflow.
- Agent calls and tokens: count tool calls and usage in the harness transcripts, for example `grep -ho '"name":"<tool>"' <transcripts> | sort | uniq -c`.
- Model spend: the provider's usage export or dashboard, read for the same period.
- Compute: resource requests against measured use in the deployment config and its metrics.

## Typical weak spots
Work repeated on every run, calls whose result is discarded, oversized models for simple steps, retries that resend everything, resources sized for peak and left running, and caches that miss.

## Evidence that counts
PROVEN: a count or bill for a stated period, with the wasted share computed from it. CLAIM: an estimate from list prices or from reading code.
