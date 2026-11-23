# Code design

**Pick when:** the work adds a module, package, interface, or extension point, or moves a boundary between modules.

## Decisions to settle

1. The caller's usage: what callers import, call, and get back, written as two or three real call sites.
2. The modules and what each one owns. Group by the knowledge a module protects, not by when its code runs.
3. Where the seams go, and which way dependencies point. The core depends on nothing at the edge. Write the answer as the map, in the project's boundary config: the slices, the layers inside each (domain, then application, then adapters, each depending only inward), and every allowed cross-slice edge, each one entering the other slice through its public `api` entry. Commit the config with the sketch, so the boundary check proves the map the way the infrastructure variant's dry run proves its config. When the repo has no boundary check, init it from the stack's template, or write it with **research** when no template exists.
4. Each interface: its signature, invariants, ordering rules, error modes, and required configuration.
5. Extension points: what a third party may add, and through which seam.
6. What the design deliberately does not do.

## Lenses

- Depth: a small interface over a large behaviour. Run the deletion test in [deep-modules.md](../deep-modules.md) on every module.
- A port only with two or more real or certain adapters: a provider swap, A/B variants behind one interface, or a test adapter for remote or external I/O. A flag on one branch is not a port, and neither is a seam with one adapter. Agents fail by over-abstracting far more than by under-abstracting, so a port must prove its second adapter. [deepening.md](../deepening.md) says which kind of dependency earns one.
- A module owns one decision and hides it. Leakage test: when changing decision X needs edits in more than one module, X leaked. Move X into one module, or merge the modules.
- Parse wire, storage, and framework types into domain types at the edge. Never put them on a public surface.
- When an interface is replaced, migrate every caller and delete the old one in the same change.
- The reason for a seam or an allowed edge is a constraint comment beside it, in the boundary config or on the port, so it changes with the thing it explains. Rejected alternatives and history go in the pull request and a **memory** note. A human-readable view of the map is generated from the config, never written by hand, and no architecture document exists.

## Pattern catalog

A pattern is a named answer to one boundary question. Name the question first, then pick the pattern. Add a pattern here only after a real design needed it.

| Pattern | Pick when | Costs | Smell when misused |
|---|---|---|---|
| Vertical slices with onion layers | Features or subdomains change independently, and each holds logic worth protecting from I/O | A public `api` entry per slice, the boundary config to keep current, and some duplication between slices instead of a shared module | Slices that reach past another slice's `api` entry. A shared or common slice that every slice imports. Layers that only pass calls through. An allowed edge with no reason beside it |
| Ports and adapters (hexagonal) | The core logic must run against two or more real backends, or a test adapter replaces I/O | One interface and wiring per port | A port with one adapter. Ports that mirror the backend's API one for one |
| Pipeline | Data moves through stages that each own one transformation, with one representation throughout | Stage contracts become the interface | The same invariant checked in every stage. Stages that need each other's internals |
| Plugin or exec adapter | Others extend the system without changing it, such as a new ecosystem or provider | A stable contract you cannot break | A plugin API with one plugin. Plugins that reach past the contract |
| Functional core, imperative shell | The logic has decisions worth testing and the I/O is thin | Effects must be returned as data | A shell that grows decisions. A core that takes clients as arguments |
| Reconcile against observed state | The system converges toward a goal on each run instead of keeping its own store | Every run reads the world, so reads must be cheap and idempotent | A hidden store added "for speed". Actions that are not safe to repeat |
