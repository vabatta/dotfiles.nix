# Compete on implementations

**Pick when:** the interface is fixed or easy to fix, and how to fill it is open enough that building two or three versions is cheaper than arguing: an algorithm, a performance-sensitive path, an integration with several plausible approaches.
**Chain:** how, architect, arena, build
**Done looks like:** the winning implementation is in production code with the shared tests green, and review has converged or reported why not.

## Steps
1. **how** over the code the implementation plugs into. Out: the traced callers and constraints.
2. **architect** when the Design gate applies. Out: stubs and failing tests.
3. **arena**, code-implementation variant. Hand it the interface and the rubric. Out: the synthesized branch and the score table.
4. **build** from the synthesized branch. It runs the red tests, subtracts, proves the result on the real artifact, and runs review. Out: green check, real-run output, net lines.

## Watch for
- Candidates that change the interface to win: that is a design question, so go back to step 2.
- A winner by one rubric point: prefer the smaller one, and graft rather than rescore.
