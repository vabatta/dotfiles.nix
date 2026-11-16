# TypeScript

**Pick when:** the repo has a `tsconfig.json` or `package.json`, or the change touches `.ts`, `.tsx`, or `.js` files.

- Find the package manager from the lockfile (`pnpm-lock.yaml`, `bun.lock`, `yarn.lock`, `package-lock.json`) and use only that one. Take the test, lint, and typecheck commands from `package.json` scripts.
- Keep the project's `strict` settings. Never loosen `tsconfig.json` to make a change compile.
- Prefer what the runtime already has over a dependency: `fetch`, `URL`, `structuredClone`, `AbortController`, `crypto.randomUUID`, `Array.prototype.at`, `Object.groupBy`, `Promise.allSettled`, `node:test` where the project uses it.
- Avoid, then use instead:

  | Avoid | Use instead |
  |---|---|
  | `any` | `unknown`, narrowed at the boundary |
  | `as` on data from outside | a parse with the project's validator, or a type guard |
  | `enum` | a union of string literals, unless the project uses enums |
  | `x \|\| default` for a possibly falsy value | `x ?? default` |
  | default exports in a new module | named exports, unless the project uses default exports |

- Validate data at the edge, once, and keep the inside of the program typed.
