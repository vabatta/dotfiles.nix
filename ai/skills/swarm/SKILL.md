---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/swarm/SKILL.md
name: swarm
description: Partitions independent exploration or verification work, aggregates the results, and returns one evidenced report.
---

# Swarm

Use a swarm when the work has genuine independent seams. Do not parallelize
shared writes.

1. State the done predicate and the report or artifact required.
2. Partition the work or define a race and its selection rule.
3. Give every worker a complete brief, an owned output location, and a proof
   requirement.
4. Run the workers through the host's delegation capability, or run the slices
   sequentially when delegation is unavailable.
5. Read the actual outputs. Do not aggregate self-reported success.
6. Report coverage, evidenced issues, gaps, and worker failures.
