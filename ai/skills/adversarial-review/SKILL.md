---
name: adversarial-review
description: "Runs independent reviewers against a design or change and classifies findings as act, consider, noted, or dismissed. Use when asked for adversarial critique of a design or change. It returns classified findings, never a merge verdict. Trigger on adversarial review, red team, poke holes, or find the flaws."
---

# Adversarial review

1. State the goal, constraints, and review rubric. Done when each is one line.
2. Fan the reviewers out per **delegate**, one read-only reviewer per rubric axis, three at most. Done when each axis has a report.
3. Read every finding and verify it per **principle-prove-it-works**. For a design with nothing to run, a finding needs a quoted line or reproduced output, else class it Consider.
4. Classify each finding.
   - Act on: evidenced and affects the stated goal.
   - Consider: plausible, evidence incomplete.
   - Noted: true but outside the goal.
   - Dismissed: disproved by a run or a quoted line.
5. Present the classified list. Edit only an artifact you authored, and nothing when report-only. Done when every finding carries a class and the list is presented.

For the interview that settles open decisions before a change exists, use **grill**.
