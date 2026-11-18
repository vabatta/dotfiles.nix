---
name: diagnosing-bugs
description: "Runs a diagnosis loop for hard bugs and performance regressions that builds a red-capable feedback loop before hypothesising, then fixes at the root. Use when the user says diagnose or debug this, or reports something broken, throwing, failing, flaky, or slow, even when they never say debug and only describe the symptom. Not for a failure whose cause is already known."
---

# Diagnosing bugs

Runs the loop that finds a root cause and fixes it there. Skip a phase only with a stated justification, and read the project glossary and any area ADRs, owned by **domain-modeling**, when exploring. Skip them when none exist.

Redact first. Replace every secret with `<REDACTED>` in commands, output, and artifacts. Build loops against environment variables so credentials stay out of files. Quote only the signal-bearing lines. If redaction leaves too little to reason about, say so and ask.

## Phase 1: Build a feedback loop

This is the skill. Build a tight pass or fail signal that goes red on this bug. Spend disproportionate effort here.

Name the failure class and read only its variant. It says how to build the loop, narrow it, where causes usually sit, and what proves the fix. Its scripts are [scripts/repeat.sh](scripts/repeat.sh) (failure rate over N runs) and [scripts/time-runs.sh](scripts/time-runs.sh) (min, median, and max wall time). When no class fits, use the ladder below.

| Variant | Pick when |
|---|---|
| [crash](references/classes/crash.md) | Same input, same exception, exit code, or wrong output every time |
| [flaky](references/classes/flaky.md) | Passes and fails with no code change |
| [performance](references/classes/performance.md) | Works but slower, more memory, or more calls than before |
| [after-change](references/classes/after-change.md) | Worked before an upgrade, bump, merge, or config change |
| [environment](references/classes/environment.md) | Works in one place, fails in another |

Construction ladder, best first:

1. A failing test at any seam.
2. A curl or HTTP script.
3. A CLI invocation with a snapshot diff.
4. A headless browser asserting DOM, console, or network.
5. A replay of a captured trace.
6. A throwaway harness with mocked dependencies.
7. A property or fuzz loop.
8. A bisection harness for `git bisect run`.
9. A differential loop, old versus new.
10. A human-in-the-loop bash script, the last resort. Use [scripts/hitl-loop.template.sh](scripts/hitl-loop.template.sh).

Tighten the loop as a product. Faster? Sharper, asserting the exact symptom rather than "did not crash"? More deterministic, with pinned time, seeded RNG, isolated filesystem, and frozen network? A 30-second flaky loop is barely better than no loop. For non-deterministic bugs the goal is a higher reproduction rate, not a clean repro. Loop many times, parallelise, stress, and narrow the timing window.

If a loop cannot be built, stop. List what you tried and ask for one of reproducing-environment access, a redacted captured artifact such as a HAR, log, core, or recording, or permission for temporary instrumentation. Do not hypothesise without a loop. When no one answers, end with that list as the report.

Completion criterion, red-capable. One named command already run once, that drives the real bug path, asserts the user's exact symptom, is deterministic (or has a measured repro rate), under 10 seconds, and agent-runnable. No red-capable command, no Phase 2.

## Phase 2: Reproduce and minimise

Run the loop. Confirm it is the user's failure mode, not a nearby one. Capture the exact symptom. Then minimise by cutting one element at a time to the smallest scenario that still goes red. Done when every remaining element is load-bearing.

## Phase 3: Hypothesise

First run a one-commit-log probe, `git log -1 -- <suspect path>` or `git log -S<symbol>`, and use **why** only when that commit explains the failure. Write three to five ranked, falsifiable hypotheses before testing any, as the table in [assets/hypotheses.md](assets/hypotheses.md). A row without a prediction is a vibe, discard it. Post the table, then continue.

## Phase 4: Instrument

Every probe maps to a prediction, and each change touches one variable. Prefer a debugger or REPL, then targeted logs at distinguishing boundaries. Never log everything and grep. Tag every debug log with a unique prefix such as `[DEBUG-a4f2]` so cleanup is one grep. For a performance regression, logs are usually wrong. Establish a baseline with a timing harness, profiler, or query plan, then bisect.

## Phase 5: Fix and regression test

Run the loop test-first per **build**, at the correct seam: the one that exercises the real bug pattern as it appears at the call site. Promote the Phase 1 test to the regression test when it sits there. A shallow seam gives false confidence. If no correct seam exists, that itself is the finding, because the architecture prevents lock-down. Then re-run the original un-minimised Phase 1 loop.

## Phase 6: Cleanup

Confirm the original repro no longer reproduces, the regression test passes or the missing seam is documented, [scripts/debug-tags.sh](scripts/debug-tags.sh) finds no `[DEBUG-...]` tag, and throwaway prototypes are deleted or marked. State the winning hypothesis in the commit or PR message. Before declaring done, check what else the change touches.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
