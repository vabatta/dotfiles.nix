---
name: build
description: "Implements a change test-first in small verified units. States the stack and a net-added-line budget before writing code, proves the result on the real artifact, and ends with a review loop. Use for any code change that adds behavior or fixes a bug. Trigger on implement, build, fix, add, change, or refactor."
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
   - **Budget.** Net added source lines, excluding tests, generated files, and lockfiles. A limit the user gives is binding, otherwise estimate it.
   - **Check.** The failing test or command that will pass.

   Track the acceptance lines and the units in your task list, since that list outlives compaction better than your memory of the plan. When the approach is unproven or several designs compete, run **figure-it-out**, which gates prototype and design. Done when acceptance, task type, stack, budget, and check are written.
2. Go red first. For a bug, reproduce it, then ask why until you reach the root cause; a guard that hides the symptom is not a fix. Grep every instance of the failing call. After a restart failure, suspect stale state first. For a feature, write the failing test whose name states the behavior. Run it and quote the failure. Done when the red run is shown and fails for the stated reason.
3. Subtract before you add. Delete dead code, one-caller wrappers, and redundant guards on the path first. A pure addition names what it removed, or says nothing needed removing.
4. Implement the smallest change, one unit at a time. Each unit ends at a passing check. Add no compatibility path, fallback, option, or refactor that no acceptance line asks for, and list what you held back in the result. Never commit red except the red-first test. Done when the check passes.
5. Prove it on the real artifact. Run the actual feature path and read the actual value. When verification fails, suspect the way you observed before the system. Script the check when you can. Done when the real run's output is quoted.
6. Audit. Count net lines with [scripts/net-lines.sh](scripts/net-lines.sh) `[base] [budget]` and report them against the budget; never reword the limit to fit. The code is the source of truth: behavior lives in test names and types, comments only state constraints the code cannot express, and you add no plan, ADR, or note that restates code. Done when the audit numbers are written.
7. Review. Run **review** on the change with the acceptance lines, unless the user said to skip it. Its fixes come back here as units. Done when review reports converged, not converged, or capped.
8. Deliver what the task asked for and nothing more. Commit, push, open a pull request, or publish only when the task says so, in the form it says, such as "in a draft PR". A pull request body follows **technical-writing**. Done when the reply follows the result block of the template. If another skill called this one, return to its next step, since this return ends the build and not the turn.

## Deciding without asking

Act on your own recommendation whenever the choice is easy to undo, and write it as a ruling: the choice, why, and the cost if wrong. Do not stop to confirm a finding you would act on anyway. Ask only for something the task leaves open that is hard to undo or changes what the user gets. When no one can answer, write your recommended answer as a ruling, continue, and list it in the result. What the user said you may or may not do overrides this section.
