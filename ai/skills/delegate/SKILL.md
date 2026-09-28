---
name: delegate
description: Use when asked to use subagents, parallelize work, or fan out research or edits. Briefs each worker with an owned output and a proof requirement, then verifies the artifacts.
---

# Delegate

Delegate only when it reduces risk or buys independent coverage.

## When to use

Use it for genuine independent seams, independent coverage, or isolated verification. Do not parallelize shared writes. Parallel fan-out is not a default: a deterministic lever beats fan-out, so if one script can do the work, run it instead. See **principle-build-the-lever**.

## Steps

1. State the done predicate and the artifact or report required.
2. Partition the work, or define the race and its selection rule.
3. Give every worker a complete brief, an owned output location, and a proof requirement.
4. Run workers through the host's delegation capability, or run the slices sequentially when it is unavailable.
5. Read the actual outputs. Do not aggregate self-reported success.
6. Report coverage, evidenced issues, gaps, and worker failures.

## Isolation

Each writer gets its own file, branch, or directory. See **principle-separate-before-serializing-shared-state**.

## Verification

Inspect the artifact, not the summary. Treat an agent's report as a pointer, not as proof. Prefer a separate reviewer for verification. See **principle-prove-it-works**.

## No delegation

If the host cannot delegate, do the work directly under the same brief and proof rules.
