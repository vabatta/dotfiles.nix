---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/recall/SKILL.md
name: recall
description: Reconstructs recent work from the current conversation, repository state, history, and any host-provided session records.
---

# Recall

Use recall before resuming work when the current state is unclear.

1. Define the workspace, topic, and time window.
2. Read the current conversation and live repository state first.
3. Search host-provided session history when available. Never invent a history
   path or read another workspace without permission.
4. Search Git history and configured external records for named work.
5. Verify branches, commits, and files against live state.
6. Return a short capsule, thread statuses, problems, and one next move.

If a history or integration source is unavailable, report the gap and continue
with the sources that exist.
