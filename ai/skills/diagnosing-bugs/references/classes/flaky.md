# Flaky

**Pick when:** the failure is intermittent: a test or behaviour that passes and fails with no code change.

## Build the loop
- Measure the rate first with the skill's `scripts/repeat.sh 50 <test command>`. Record "failed K of N".
- Raise the rate until a run fails in seconds: run in parallel, add CPU load, shrink timeouts, randomise test order, run the one test alone and in the full suite.
- Pin everything you can: time, random seeds, locale, timezone, network, and the filesystem (a fresh temp directory per run).

## Narrow it
- Alone versus in the suite: if it only fails in the suite, bisect the test order to find the test that leaks state.
- Fast versus slow machine: if load raises the rate, it is timing. Look for sleeps, polling, and unawaited work.
- Read the failing runs' output side by side with a passing run's. The first line that differs is the lead.

## Typical root causes
Shared state between tests (globals, a database, files, ports), a race between async work and an assertion, a fixed sleep instead of waiting for a condition, dependence on wall-clock time, test order, or map iteration order.

## Proof of fix
Zero failures over at least three times the runs that showed the bug at the measured rate (if 1 in 20 failed, 60 clean runs), under the same load.
