# Code design

**Pick when:** the work adds a module, package, interface, or extension point, or moves a boundary between modules.

## Decisions to settle

1. The caller's usage: what callers import, call, and get back, written as two or three real call sites.
2. The modules and what each one owns. Group by the knowledge a module protects, not by when its code runs.
3. Where the seams go, and which way dependencies point. The core depends on nothing at the edge.
4. Each interface: its signature, invariants, ordering rules, error modes, and required configuration.
5. Extension points: what a third party may add, and through which seam.
6. What the design deliberately does not do.

## Lenses

- Depth: a small interface over a large behaviour. Run the deletion test in [deep-modules.md](../deep-modules.md) on every module.
- A port only where two adapters exist or are certain. One adapter is a hypothetical seam. [deepening.md](../deepening.md) says which kind of dependency earns one.
- Parse wire, storage, and framework types into domain types at the edge. Never put them on a public surface.
- When an interface is replaced, migrate every caller and delete the old one in the same change.

## Pattern catalog

A pattern is a named answer to one boundary question. Name the question first, then pick the pattern. Add a pattern here only after a real design needed it.

| Pattern | Pick when | Costs | Smell when misused |
|---|---|---|---|
| Ports and adapters (hexagonal) | The core logic must run against two or more real backends, or a test adapter replaces I/O | One interface and wiring per port | A port with one adapter. Ports that mirror the backend's API one for one |
| Pipeline | Data moves through stages that each own one transformation, with one representation throughout | Stage contracts become the interface | The same invariant checked in every stage. Stages that need each other's internals |
| Plugin or exec adapter | Others extend the system without changing it, such as a new ecosystem or provider | A stable contract you cannot break | A plugin API with one plugin. Plugins that reach past the contract |
| Functional core, imperative shell | The logic has decisions worth testing and the I/O is thin | Effects must be returned as data | A shell that grows decisions. A core that takes clients as arguments |
| Reconcile against observed state | The system converges toward a goal on each run instead of keeping its own store | Every run reads the world, so reads must be cheap and idempotent | A hidden store added "for speed". Actions that are not safe to repeat |
