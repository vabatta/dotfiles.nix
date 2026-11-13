---
name: unattended
description: "Sets the contract for a run no one is watching, covering scope, done condition, caps, what may be published, and what to do when stuck. Use before a long or scheduled run, a /goal that runs overnight, or work started by a schedule or webhook. Trigger on overnight, unattended, while I am away, or run on its own."
---

# Unattended

T3 and Claude impose no run limit, so this contract is the limit.

1. Write the contract as the first message and save it with `mem_save` (type decision, `topic_key` `run/<slug>`). Fill in [assets/contract.md](assets/contract.md): goal, done command, scope, cap, workspace, allowed one-way actions, and start commit. Done when all seven fields are filled.
2. Drive each unit with **figure-it-out**, gates included. The contract replaces its questions: steps 3 and 4 below decide what it would ask. Commit each green unit and never a red one. When a unit fails its check three times, revert it, save a learning record marked `NEEDS MANUAL REVIEW` with the failure, and move on. A check that cannot run stops the run.
3. Do not ask. When a product decision blocks, write your recommended answer as an assumption in the record and continue. At a one-way door, stop and report.
4. Stop at the first of: the done command passes, the cap is reached, or no unblocked unit is left. Every three units refresh the session summary so a fresh agent could continue.
5. Write the final report in the shape of [assets/report.md](assets/report.md), led by the done command's result.
