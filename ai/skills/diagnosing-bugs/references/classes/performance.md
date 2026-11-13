# Performance regression

**Pick when:** it works but got slower, uses more memory, or makes more calls than before.

## Build the loop
- Pick one operation that shows the slowdown and time it repeatedly: the skill's `scripts/time-runs.sh 10 <command>` gives min, median, and max wall seconds. Compare medians, never single runs.
- Fix the input size and warm the cache the same way on every run. State the threshold that counts as red, for example median above 1.5 s.
- For memory or call counts, assert the number: peak memory from the runtime, query count from the log, request count from the client.

## Narrow it
- When there is a known good version, bisect with the timing threshold as the `git bisect run` predicate.
- Profile before guessing: a CPU profile, a query plan (`EXPLAIN`), or allocation counts. Logs are usually the wrong tool here.
- Scale the input by 2 and 10: a time that grows faster than the input points at an algorithm, not a constant.

## Typical root causes
A query inside a loop (N+1), a missing index, a cache that no longer hits, a quadratic loop over a list that grew, work moved onto a hot path, a debug or logging setting left on, a dependency upgrade.

## Proof of fix
The median is back under the threshold on the same input, and a benchmark or a test asserting the count (queries, calls) guards it.
