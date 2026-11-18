---
name: unattended
description: "Sets the contract for a run no one is watching, covering scope, done condition, caps, what may be published, and what to do when stuck. Use before a long or scheduled run, a /goal that runs overnight, or work started by a schedule or webhook. Trigger on overnight, unattended, while I am away, or run on its own."
---

# Unattended

The harness may impose no run limit, so this contract is the limit.

1. Write the contract as the first message and save it to `.agents/runs/<slug>.md`. Fill in [assets/contract.md](assets/contract.md): goal, done command, scope, cap, workspace, allowed one-way actions, and start commit. Done when all seven fields are filled.
2. Drive each unit with **figure-it-out**, gates included. The contract replaces its questions: steps 3 and 4 below decide what it would ask. Commit each green unit and never a red one. When a unit fails its check three times, revert it, since a fourth try on the same approach rarely differs and the cap is better spent on other units, add the failure to the contract file marked `NEEDS MANUAL REVIEW`, and move on. A check that cannot run stops the run.
3. Do not ask. When a product decision blocks, write your recommended answer as an assumption in the contract file and continue. At a one-way door, stop and report.
4. Stop at the first of: the done command passes, the cap is reached, or no unblocked unit is left. Every three units, update the progress in the contract file so a fresh agent could continue, because a long run can lose its context or its machine at any point.
5. Write the final report in the shape of [assets/report.md](assets/report.md), led by the done command's result.
