---
name: figure-it-out
description: "Turns a vague or open goal into a checkable done condition, picks the route through the skill set, and drives it to the end on its own, deciding reversible steps and asking only at one-way doors. Use when given a goal without a method or told to handle something end to end. Trigger on figure it out, fix it, sort it out, deal with it, handle this, make it work, or a short instruction that names an outcome but no steps."
---

# Figure it out

A conductor. It adds no method of its own: every step is another skill. Its job is to frame the goal, choose the route, and keep going until the done condition holds.

1. Ground. Read the state before asking anything: the code, `git status`, the open threads and PRs the goal touches, and `gm search` on its area. Facts are found, never asked. Done when you can say what exists today and what the goal changes.
2. Frame. Write the goal as a done condition someone can check: a command that exits 0, a value read off the real artifact, or a verdict given. Name the scope and every one-way door on the path (force-push, deleting data, sending outside, a public interface). When the goal holds several unrelated outcomes, split it into units and finish them one at a time, in dependency order. Done when each unit has a done condition.
3. Pick a playbook. Choose the first row below that fits the unit and read only that playbook, then follow it. A unit that changes code also passes the gates in [references/gates.md](references/gates.md): understand, examine, decide, de-risk, design, compare, build. The playbook says which gates apply. Name the playbook and the gates you will run in one line before starting. Done when every unit has a playbook and a gate plan.

   | Playbook | Pick when |
   |---|---|
   | [decide](references/playbooks/decide.md) | A proposal or open question to settle before code |
   | [change-code](references/playbooks/change-code.md) | You know what to build or change |
   | [compete-impl](references/playbooks/compete-impl.md) | The interface is fixed and how to implement it is open |
   | [fix-bug](references/playbooks/fix-bug.md) | Something fails and the cause is unknown |
   | [refactor](references/playbooks/refactor.md) | Same behaviour, better shape |
   | [examine](references/playbooks/examine.md) | A quality goal with no change on the table yet |
   | [try-idea](references/playbooks/try-idea.md) | Nobody knows if the approach works |
   | [understand](references/playbooks/understand.md) | The goal is knowledge, not a change |
   | [run-unattended](references/playbooks/run-unattended.md) | Long or scheduled work no one watches |
   | One skill does it | **research** outside the repo, **nixification** for a missing tool, **wizard** for human-only steps, **to-questionnaire** when a third person knows, **writing** for docs, PRs, commits, skills, and prompts |
4. Drive. Run the route's skills in order and hand each one the previous step's output. Decide reversible choices yourself and record each as an assumption. At a one-way door or a product decision, ask once with your recommended answer, since those are the choices the user would want to own and the recommendation lets them answer in one word. When no one answers, take the safe side of the door and continue with the rest, so one open question does not stall the whole goal. A skill that returns has ended its own step, not the run, so continue with the next one. When a step changes the picture, for example a verdict of don't or a root cause in another subsystem, re-route instead of pushing on. Done when the done condition holds or the unit is blocked on a named one-way door.
5. Report in the shape of [assets/report.md](assets/report.md). Save the decisions that are hard to reverse with **memory**. Done when every unit has a status and its proof.

Work that will outlive the session or run with no one watching goes through **unattended** first. Its contract then drives each unit through this skill, with the contract's rules in place of questions.
