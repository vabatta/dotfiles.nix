# Coupling

**Pick when:** the goal is that a change to one feature stays inside it: slices that change together, imports that cross the map, cycles, and seams that do not earn their cost.

## What to measure
- Co-change: commits that touch more than one slice, and which pairs of slices change together most.
- Import cycles: modules or slices that import each other, directly or through a chain.
- Ports against adapters: each port and the count of its real adapters. A test adapter counts only when it replaces remote or external I/O.
- The boundary baseline: the known violations the boundary config still tolerates, their count, and whether the count falls over time.

## How to measure
- Co-change, with `depth` set to the path depth of a slice (2 for `src/billing`):

  ```bash
  git log --since=6.months --format=format:@ --name-only -- <slice root> | awk -F/ -v depth=2 '
    /^@/ { flush(); next }
    NF > depth { k = $1; for (i = 2; i <= depth; i++) k = k "/" $i; if (!(k in s)) { s[k] = 1; n++ } }
    END { flush() }
    function flush(  a, b) { if (n > 1) for (a in s) for (b in s) if (a < b) print a " + " b; for (a in s) delete s[a]; n = 0 }
  ' | sort | uniq -c | sort -rn | head -20
  ```

- Cycles and crossings: run the boundary check and read what it reports. When the repo has none, or it has no cycle rule, dump the import graph with the stack's tool and list the strongly connected components.
- Ports: `git grep -nw '<Port>'` for each port, then count the types that satisfy it, outside tests unless the test adapter replaces remote or external I/O.
- Baseline trend: count the tolerated entries in the boundary config now and at a commit six months back, with `git show <sha>:<config path>`.

## Typical weak spots
A shared or common slice that every slice imports, two slices that change together in most commits because the split is in the wrong place, an allowed edge with no reason beside it, a port with one adapter, a wire type re-exported from a slice's `api` entry, and a baseline that only grows.

## Evidence that counts
PROVEN: a co-change count from the history, a cycle printed by a tool, a port shown with its adapter count, or a baseline count compared across two commits. CLAIM: "too coupled" with no count, or an import that looks like a crossing on a repo where the boundary check was never run.
