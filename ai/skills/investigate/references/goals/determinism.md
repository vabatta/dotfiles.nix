# Determinism

**Pick when:** the goal is that the same input gives the same result: flaky tests, builds that differ run to run, agent or script output that wanders.

## What to measure
- Repeat agreement: how many of N identical runs give an identical result.
- Flake rate: tests that pass and fail on the same commit.
- Hidden inputs: time, randomness, ordering of maps or files, network, environment, and the machine.

## How to measure
- Repeat and hash: `for i in 1 2 3 4 5; do <command> > "out.$i"; done; cksum out.*`, then diff the outputs that differ.
- Same commit, different result: `gh run list --limit 100 --json headSha,conclusion,name | fx '.filter(r => r.conclusion)'`, grouped by `headSha`.
- Hidden inputs: `git grep -nIE 'time\.Now|Date\.now|Math\.random|rand\.|uuid|sleep|os\.Getenv|process\.env' -- <path>`.
- Order: rerun with a shuffled test order, or a different `TZ`, `LANG`, or working directory.

## Typical weak spots
Iteration over unordered maps or directory listings, timestamps in outputs, tests sharing state or ports, sleeps used as synchronization, unpinned dependencies or model versions, and prompts without a fixed output shape.

## Evidence that counts
PROVEN: differing hashes across repeats, or a test that failed and passed on the same commit. CLAIM: a hidden input found by grep but not shown to change the result.
