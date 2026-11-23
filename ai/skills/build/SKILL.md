---
name: build
description: "Implements a change test-first in small verified units. States the stack before writing code, proves the result on the real artifact, and ends with a review loop. Use for any code change that adds behavior or fixes a bug whose cause is known. Trigger on implement, build, add, change, refactor, or fix this when the fix is clear. Not for a failure whose cause is still unknown."
---

# Build

1. Frame the unit in one message, in the shape of [assets/frame-and-result.md](assets/frame-and-result.md).
   - **Acceptance.** Write what done means as lines in the user's own words. Keep their key terms: "configurable" means a setting the user changes, not detection the code does. Anything outside these lines is out of scope.
   - **Task type.** Pick one from [references/tasks.md](references/tasks.md) and read only its section.
   - **Language.** Pick the file for the repo's language and read only that one. With none matching, the rules here alone apply.

     | Variant | Pick when |
     |---|---|
     | [go](references/lang/go.md) | A `go.mod`, or `.go` files in the change |
     | [typescript](references/lang/typescript.md) | A `tsconfig.json` or `package.json`, or `.ts` and `.js` files |
     | [python](references/lang/python.md) | A `pyproject.toml` or `requirements*.txt`, or `.py` files |

   - **Stack.** Take the first option that fully works: the change is not needed; the codebase already has it, so use it the way its neighbors do; the standard library or a platform feature; a dependency already installed; a well-known library, compared from sources with **research**; the minimum new code. A stack named by the task or by `AGENTS.md` is binding. Search manifests, imports, and call sites before proposing new code.
   - **Check.** The failing test or command that will pass.

   Track the acceptance lines and the units in your task list, since that list outlives compaction better than your memory of the plan. When the approach is unproven, run **prototype** first. When the change adds a module, an interface, a data shape, or infrastructure, or several designs compete, run **architect** first and build against its sketch. Done when acceptance, task type, stack, and check are written.
2. Go red first. For a bug, reproduce it, then ask why until you reach the root cause; a guard that hides the symptom is not a fix. Grep every instance of the failing call. After a restart failure, suspect stale state first. For a feature, write the failing test whose name states the behavior. Run it and quote the failure. Done when the red run is shown and fails for the stated reason.
3. Subtract before you add. Delete dead code, one-caller wrappers, and redundant guards on the path first. A pure addition names what it removed, or says nothing needed removing.
4. Implement the smallest change, one unit at a time. Each unit ends at a passing check. Add no compatibility path, fallback, option, or refactor that no acceptance line asks for, and list what you held back in the result. Never commit red except the red-first test. Keep the boundary check passing in every stack. When the repo has none, init it from the stack's template, or write it with **research** when no template exists, recording today's imports as the starting map. Never loosen the boundary config to make a change pass, because the config is the map and only the owner changes it. A change that truly needs a new cross-slice edge goes back to **architect** as a map change. Done when the check passes.
5. Prove it on the real artifact. Run the actual feature path and read the actual value. When verification fails, suspect the way you observed before the system. Script the check when you can. Done when the real run's output is quoted.
6. Audit. Count net added source lines with [scripts/net-lines.sh](scripts/net-lines.sh) `[base]` and report them, so a change that grew past its need shows. When the user gave a size limit, report against it and never reword it to fit. The code is the source of truth: behavior lives in test names and types, comments only state constraints the code cannot express, and you add no plan, ADR, or note that restates code. Done when the audit numbers are written.
7. Review. Run **review** on the change with the acceptance lines, unless the user said to skip it. Its fixes come back here as units. Done when review reports converged, not converged, or capped.
8. Deliver what the task asked for and nothing more. Commit, push, open a pull request, or publish only when the task says so, in the form it says, such as "in a draft PR". A pull request body follows **writing**. Done when the reply follows the result block of the template. If another skill called this one, return to its next step, since this return ends the build and not the turn.

## Deciding without asking

[references/decision-rights.md](references/decision-rights.md) says who settles each kind of decision, with the user present and absent. Read it before you ask, or decide anything that touches the map, a port, a merge, or a stalled finding. For everything easy to undo, act on your own recommendation and write it as a ruling: the choice, why, and the cost if wrong. Do not stop to confirm a finding you would act on anyway. What the user said you may or may not do overrides the table.
