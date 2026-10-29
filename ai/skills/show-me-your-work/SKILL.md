---
name: show-me-your-work
description: "Appends each decision, reason, evidence, and result to a TSV trail while a run proceeds. Use on any run with forks, pivots, or blockers, or when asked for a decision log, audit trail, or show your work."
---

# Show me your work

Every run keeps a decision trail, so a human reviewing after the fact can reconstruct what was decided, why, and on what evidence, without rerunning the work or reading the whole transcript. Keep one canonical log so a future agent can find it.

## The format

A single TSV file, one row per decision. TSV because GitHub renders it as a sortable table, `column -s$'\t' -t` and spreadsheets read it, and a row appends with one command. Cells stay single-line. Evidence is a pointer, not prose.

`scripts/log.sh` writes the header on first use, so copying `references/decision-log-template.tsv` is only needed for manual appends. Columns:

- **ts.** ISO8601 timestamp. The timeline axis.
- **phase.** The phase or workstream.
- **decision.** What was chosen or done, one line.
- **why.** The reason in plain words. If a principle drove it, say it plainly (`explored options first, this was a one-way door`), not as a jargon tag.
- **evidence.** A link or path that proves it: commit SHA, PR number, `file:line`, or an artifact, trace, or screenshot path. Never a paragraph.
- **result.** The outcome or predicate state: `tests green`, `reverted`, `pixel-diff 0`, `INCONCLUSIVE`, `open`.

An example, plain-spoken so a reviewer reads it at a glance. This is illustration only; don't copy these rows into a real log.

```
ts	phase	decision	why	evidence	result
2026-05-24T09:02:00Z	frame	counted the work first, about 100 components and roughly 75 hours	wanted to know the size before starting a long run	commit 3a9f1c2	found 5 things to sort out before starting
2026-05-24T09:40:00Z	harness	took screenshots of the old version before changing anything	so we can compare old against new and catch any visual change	scripts/snapshot.sh, baseline/	saved 120 reference screenshots
2026-05-24T11:15:00Z	widget	moved the widget styles over without changing how it looks	keep the change small and the result identical	commit 7c21e0a, pixel-diff 0	looks identical, tests pass
2026-05-24T12:30:00Z	widget	threw out a helper's work because its screenshots were blank	checked the real files instead of trusting its summary	worktree reset	reverted, tightened the instructions for next time
```

## Logging a row

Write each entry the way a teammate would be told what was done. Plain words, concrete actions, no AI speak or abstract jargon (the **unslop** skill applies to log text too). A reviewer should understand each row without decoding it.

Use the helper (path relative to this skill's directory) so rows stay well-formed: `scripts/log.sh <logfile> <phase> <decision> <why> <evidence> <result>`. It stamps `ts`, writes the header on first use, strips stray tabs/newlines, and prefixes any cell starting with `=`, `+`, `-`, or `@` with a single quote so a reviewer opening the log in a spreadsheet doesn't trigger formula execution. The leading quote is expected in a terminal view. A bare `printf` appending a row works too, but mind those same bytes if cells come from generated or user-supplied text. To log a check's outcome, run `scripts/log-run.sh <logfile> <phase> <decision> <why> -- <command>`. It runs the command and records the real exit code and last output line, failures included, so the result is never hand-typed.

Log decision points and checkpoints, not every action: a fork chosen, a unit completed with its verification result, a pivot or revert with its trigger, a blocker surfaced, a gate fixed. For loop runs, one row per iteration.

## Where it lives

The log is the agents' own record, committed with the work. Always write it to `.agent/decisions/<slug>.tsv`, never to `docs/`. It keeps the run honest, and **consolidate** keeps ledgers when it trims the folder.

Promote it to `docs/decisions/<slug>.tsv` only when the user asks for the trail under `docs/`, or the task text says a reviewer needs one there. Size alone is not a reason. Without that request, offer promotion in the final report and leave the log where it is.

## Rules

- One row is one decision or checkpoint. If it doesn't fit on one line, the decision isn't crisp yet.
- Append-only once handed over. A wrong call gets a new row that supersedes it. The audit below may edit the working log before handover.
- Prefer evidence produced by committed scripts over hand-made one-offs, so a reviewer can re-run it (**principle-encode-lessons-in-structure**).
- Never put a secret, token, or personal data in a cell. The log is committed, and git history keeps what a later edit removes.

## Audit the log against the work

An ambitious run has a promoted trail, more than 10 units or call sites, more than one session, a one-way door, or a user who reviews it after stepping away. At the end of an ambitious run, before handing back, check that the log matches what actually happened. Compare it with a host-provided session record when one is available, then inspect the files, commands, and artifacts named as evidence.

- Every row maps to a real action. Cut invented or aspirational entries.
- Each row's evidence resolves and shows what the row claims.
- A fork, pivot, or abandoned approach that shaped the work but isn't logged is a gap. Add it.
- Drop padding. If nobody would audit a row, it doesn't earn its place.

Fix the log, not the story. If the work diverged from what a row claims, the row is wrong.

## Cross-model review of the trail

Required for an ambitious run. Before handing back, fan out a read-only reviewer per **delegate**, asking for diverse coverage so the reviewer runs on a different model from the one that did the work. The point is fresh eyes the author cannot bring. When no reviewer can run, self-review and write `reviewed by none (self only)`. The subagent reads the audit trail and the host's session record when one exists (pass its path), else `git log -p <base>..`, and states which one it used. It then flags what the user should pay attention to. Not a redo of the work, a scan for what's suboptimal or risky.

- Decisions logged with weak or absent evidence.
- Verification steps skipped or claimed without proof in the transcript.
- Choices that look risky in hindsight (premature, scope-creeping, papering over a symptom).
- Gaps the user would otherwise miss on a casual skim.

Every reply for an ambitious run ends with an "Attention" section. Lead with the reviewer's model on its own line (`reviewed by <model>` or `reviewed by none (self only)`), then list each flag pointing to specific rows or moments. "No flags" is a valid value; the model name is not. Done when the section names a reviewer line and every flag cites a row.
