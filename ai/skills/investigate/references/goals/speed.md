# Speed

**Pick when:** the goal is that it runs faster: latency, throughput, build or test time, startup time.

## What to measure
- Wall time of the exact path the user waits on, with its spread (median and worst of several runs), not one run.
- Where the time goes: which step, call, or query takes the largest share.
- Scaling: time at today's size and at ten times today's input.
- Cache hits: how often a build or query redoes work it already did.

## How to measure
- Timing: `nix shell nixpkgs#hyperfine --command hyperfine --warmup 2 --runs 10 '<command>'`.
- Steps: time each stage with the shell's `time` keyword, or read the tool's own timing output (test runner durations, `nix build` logs, CI step times from `gh run view <id>`).
- Profiles: the language's own profiler (`go test -cpuprofile`, `node --cpu-prof`, `python3 -m cProfile`).
- Ten-times input: generate or duplicate fixtures and rerun the same timing.

## Typical weak spots
Work repeated per item that could run once, N+1 queries, sequential steps that do not depend on each other, cache keys that change on every run, and large dependencies loaded at startup.

## Evidence that counts
PROVEN: a timing with runs and spread, before and after numbers, or a profile naming the hot path. CLAIM: code that looks slow but was never timed.
