# Code implementation

**Pick when:** the module's interface is fixed and how to fill it is not obvious: the algorithm, the control flow, the error model, the concurrency, or the performance target.

The output is still a sketch: the internal functions as stubs with pseudocode, and tests at the module's interface. The bodies are written after the design hands off.

## Decisions to settle

1. The algorithm and its cost: time, memory, and calls to the outside, at the sizes that matter.
2. The control flow: the main path in at most three hops, and where it branches.
3. The error model: which errors the caller can act on and receives as values, which ones abort, and what is retried, how often, and with what backoff.
4. Concurrency: what runs in parallel, what is shared, and who owns each piece of shared state. A lock the design did not plan for means the design is wrong.
5. Effects: which steps touch the outside, and in what order, so a crash halfway leaves a state the next run can recover from.
6. The internal seams that tests need, kept private to the module.

## Lenses

- Business logic as pure functions. The shell that does I/O stays thin.
- The standard library or an installed dependency before new code, since internals are where reinvented helpers hide.
- Short call chains. If following the flow takes more than three files, flatten it.
- Test at the interface and assert outcomes, not internal state, so the tests survive a rewrite of the internals.
