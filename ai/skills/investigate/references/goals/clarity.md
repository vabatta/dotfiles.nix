# Clarity

**Pick when:** the goal is code that is easier to read and change: structure, naming, duplication, dead code, comment noise.

## What to measure
- Hotspots: files that change most often and are also the largest.
- Dead code: symbols, files, and flags with no caller.
- Duplication: the same logic written in more than one place.
- Concept count: names used for the same thing, and layers that only pass calls through.

## How to measure
- Churn: `git log --since=6.months --name-only --format= -- <path> | sort | uniq -c | sort -rn | head -20`.
- Size: `git ls-files <path> | xargs wc -l | sort -rn | head -20`.
- Callers: `git grep -nw '<symbol>'`. A symbol whose only match is its definition is dead.
- Duplication: grep for a distinctive line of the suspected copy, or `nix shell nixpkgs#jscpd --command jscpd <path>`.
- Comment noise: `git grep -cE '^[[:space:]]*(//|#)' -- <path>`, then read the densest files.

## Typical weak spots
High-churn large files, one-caller wrappers, flags that are always on, copied validation, comments that restate the code, and two names for one concept.

## Evidence that counts
PROVEN: a churn or size count, a symbol shown to have no callers, or two code paths shown to be the same logic. CLAIM: "hard to read" with no count or example.
