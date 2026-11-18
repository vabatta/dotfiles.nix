---
name: review
description: "Reviews a change with fresh-context reviewers, validates every finding against the code, fixes the real ones, and repeats until a round finds nothing new, then reports what was fixed, rejected, and left open. Use when a change is ready for review, when asked to review a diff, branch, or PR, look this over, check my changes, or fix what a review found, even when they only ask whether it is good to merge."
---

# Review

A loop that ends on evidence, not on a feeling of done. The builder reviewing its own work in the same context sees what it meant to write, not what it wrote, so every pass here comes from a reviewer that did not write the change. Nothing here commits, pushes, or opens anything. Delivery is whatever the task asked for.

1. Scope. Name the change under review: the diff against its base, and the acceptance lines it must meet. Take them from the task or from **build**'s frame. When no acceptance lines exist, write them from the task in the user's own words. Pick the language file for each language in the diff from the table below. Done when the diff, the acceptance lines, and the language files are named. An empty diff has nothing to review, so say so and stop.

   | Variant | Pick when |
   |---|---|
   | [go](references/lang/go.md) | The diff touches `.go` files or `go.mod` |
   | [typescript](references/lang/typescript.md) | The diff touches `.ts`, `.tsx`, `.js`, or `package.json` |
   | [python](references/lang/python.md) | The diff touches `.py` or `pyproject.toml` |

   Read only the matching files. With none matching, the brief alone applies.

2. Fresh review. Dispatch a reviewer with fresh context, as a subagent where you can. Give it [references/reviewer-brief.md](references/reviewer-brief.md) with the diff, the acceptance lines, and the chosen language files. Do not pass your own account of the change, since a reviewer handed the builder's claims tends to confirm them. With no way to start a fresh context, run the brief yourself after rereading only the diff, and say so in the report. Done when the reviewer's findings are in hand as it wrote them.

3. Validate. Check each finding against the code before acting on it, because most review comments that developers reject are false positives. Mark each one:
   - `valid`: you reproduced it or read the line that proves it.
   - `rejected: <reason>`: the code shows it is not a defect, or it asks for scope nobody requested.
   - `deferred`: real, but minor or outside the change.

   Done when every finding has a mark and a reason.

4. Fix. Hand the valid blocking findings to **build** as units, each with its finding as the failing check. Done when each fix is green.

5. Re-check. Resume the same reviewer where you can, because it knows its own findings best. Ask it, for each finding, whether the fix addressed it, and to review the fix diff for new breakage. Where it cannot be resumed, start a fresh one with the finding list and the rejected reasons. Validate new findings as in step 3. Repeat steps 4 and 5 until a stop rule below holds.

6. Final pass. When the rounds converge, dispatch one more reviewer that has seen none of the earlier rounds, on a different model or provider if you have access to one, over the whole change. A second model catches what the first one is blind to. Its valid findings go back through steps 4 and 5. Done when the final pass yields no new valid blocking finding.

7. Report to the user in the best form you have, through **report** when it fits. Fill [assets/report.md](assets/report.md). Save a lesson that will matter on the next change with **memory**. Done when the report is shown. If another skill called this one, return to its next step, since this return ends the review and not the turn.

## Stop rules

The loop has no round limit of its own. It stops on one of these:

- **Converged.** A round gives no new valid blocking finding. Deferred findings go into the report, not into more rounds.
- **Stalled.** The same finding stays open after its fix, comes back after being fixed, or the count of blocking findings stops falling. Escalate once: hand the finding to a fresh implementer, on a stronger model where you can. If it still holds, write a ruling with both arguments and mark the result `not converged`.
- **Capped.** A limit the user set, such as rounds, time, or one pass only, overrides the rules above. Reaching it is `capped, not converged`, never done.

Two rules keep the loop from churning. A reviewer may not re-file a rejected finding without new evidence. A finding outside the change never extends the loop.
