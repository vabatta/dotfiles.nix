# TypeScript

**Pick when:** the diff touches `.ts`, `.tsx`, `.js`, or `package.json`.

Hunt for what reviewers of TypeScript code most often miss:

- `any`, `as`, or a non-null `!` that silences a real type error. An `as` cast on data from outside the program, such as JSON or a request body, with no runtime check.
- A promise that is not awaited, so its rejection is lost. `forEach` with an async callback. `Promise.all` where one failure should not cancel the rest.
- `==` coercion, truthiness checks that treat `0` or `""` as missing, and `||` where `??` was meant.
- Shared mutable state: a default parameter or a module-level object mutated per call. An object spread that copies only one level.
- In React: a missing effect dependency, an effect with no cleanup, state derived from props and then left stale, and a key that is an array index on a list that reorders.
- A dependency added for something the platform already has, such as `fetch`, `structuredClone`, `URL`, `crypto.randomUUID`, or `Array.prototype.at`.
- A test that never fails: an async test that does not await its assertion, or a mock that returns what the test then checks.
