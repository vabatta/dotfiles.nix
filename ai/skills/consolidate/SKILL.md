---
name: consolidate
description: "Trims and consolidates the .agent folder so it stays a useful knowledge base instead of growing without bound. Commits first, keeps ledgers and live work, records lasting conclusions, and retires finished working files. Use periodically, when .agent has grown noisy, or when asked to clean up, tidy, prune, or consolidate the agent folder."
---

# Consolidate

`.agent/` is always committed, so git history is the archive. Anything deleted here stays readable with `git show <sha>:<path>`.

1. Inventory with `scripts/inventory.sh [days]` (path relative to this skill's directory, repo as the cwd). The default age is 30 days. It lists tracked files only, so run it again after step 2. Done when you have the size per area and the aged file list.
2. Make deletion recoverable. When `.agent/` is gitignored, remove that ignore line. Make sure `.agent/.gitattributes` holds `INDEX.md merge=union`, `handoffs/reflect-backlog.md merge=union`, and `decisions/*.tsv merge=union`, so parallel branches append to shared files without conflicts. Commit every uncommitted change under `.agent/`. Done when `git status --porcelain .agent` is empty and the inventory prints no warning.
3. Classify each aged item as Keep, Promote, or Retire, with a one-line reason. Done when every item has a class.
   - Keep: ledgers (`.agent/decisions/*.tsv`, never edited or deleted), a handoff whose branch is unmerged or whose issue is open, a live plan or contract, `handoffs/reflect-backlog.md` while it has open items, anything a kept file or open issue points at. When unsure, Keep.
   - Promote: an item the user asked to promote, or a note a reviewer needs after the run. Move it under `docs/`: `adr/`, `specs/`, a glossary, or `decisions/` for a trail.
   - Retire: a finished run directory, brief, generated report (rebuildable from its JSON), teaching note or eval tree whose run ended, prototype with its verdict recorded elsewhere, answered questionnaire, finished wizard, or consumed handoff.
4. Record lessons. `.agent/INDEX.md` holds the lessons that are not worth a check. Add one line per lesson to it as `<date> <slug>: <lesson> (<path>@<sha>)`. A lesson is the conclusion of a Retire item that no ADR, spec, issue, or commit holds, or a row of an aged ledger that changed what we do: a pivot, revert, rejected option, failed approach, or NOT VERIFIED or INCONCLUSIVE result. Skip what lives elsewhere. Never edit a ledger. Done when each Retire item and each aged ledger has its lines or a skip reason.
5. Check for dangling references. Grep the repo for each retire path. A live pointer from `docs/`, a kept file, or an open issue moves the item to Keep. Done when no live pointer remains.
6. Delete the Retire items and commit them with the `.agent/INDEX.md` lines and any Promote moves as one commit, `agent: consolidate`, with the retired paths in the body, so one revert undoes it. Deleting does not remove an item from history, so when a retired item held a secret, rotate the secret and say so in the reply. Reply with files and lines before and after, and the Keep, Promote, and Retire counts. Done when the commit exists and the inventory shows the new size.
