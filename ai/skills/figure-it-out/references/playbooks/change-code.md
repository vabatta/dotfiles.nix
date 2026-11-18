# Change code

**Pick when:** you know what to build or change: a feature, a behaviour change, a migration, a config change.
**Chain:** architect, build
**Done looks like:** the check passes on the real artifact, and review has converged or reported why not.

## Steps
1. Run the gates in `references/gates.md` in order. Understand always applies to code not yet traced. Decide, de-risk, design, and compare run only on their conditions.
2. **architect** when the unit adds a module, an interface, a data shape, or infrastructure. It picks its variants, settles each decision with the user when present, and runs **arena** on sketches when designs compete. Out: compilable stubs and failing tests.
3. **build**. Hand it the design, or the one-line change. Out: green check, real-run output, net lines.

## Watch for
- The same deviation from the sketch appearing again and again during build: the sketch is wrong. Go back to **architect** with what was learned instead of bolting on fixes.
- Implementation is the open question rather than the shape: switch to compete-impl.
- Activating, deploying, or publishing: a one-way door unless the user asked for it. Build and verify, then ask.
- Several unrelated changes at once: split them into units, and deliver each one the way the task asks.
