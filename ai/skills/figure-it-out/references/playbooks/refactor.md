# Refactor or clean up

**Pick when:** the behaviour stays the same and the shape improves: simplify, remove duplication, rename, delete dead code, tidy comments.
**Chain:** how, build
**Done looks like:** the same tests pass before and after, net lines went down or the reason is stated, and review has converged or reported why not.

## Steps
1. **how** over the area. Out: the call graph and every caller of what changes.
2. Gates from `references/gates.md`: examine when the target is vague ("clean this up"), design when an interface changes.
3. **build** in small units: subtract first, then move. Run **no-comments** on the touched files.

## Watch for
- A behaviour change hidden in a refactor: split it into a change-code unit.
- An interface used by other repos: a one-way door.
