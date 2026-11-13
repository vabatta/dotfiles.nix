---
name: review
description: "Takes a branch to a reviewed pull request. Runs the checks, opens the PR, reads PR-Agent's findings, fixes the real ones, and answers the rest. Use when work is ready for review or when PR-Agent has commented. Trigger on open a PR, address review comments, or ready for review."
---

# Review

1. Run the project check and confirm it is green. Done when the run output is quoted.
2. Open or update the PR with `gh pr create`. The body says what changed and why in plain words. Done when the PR URL is in the reply.
3. Wait for PR-Agent. Ask the thread to watch the PR; it reports checks and conflicts. Read the findings with `gh pr view --comments`. A repo without PR-Agent is a setup gap: say so and stop. Done when the findings are listed.
4. Classify each finding: **fix** (real defect, missing test, or drift between code and what is said about it), **reply** (you disagree; give the reason in one line), **skip** (style noise). Fix small findings yourself, each as a new unit through `build` steps 2 to 5. Start no other reviewer for small findings. For a high-risk change (data loss, security, a shared contract), start one independent review in its own worktree: `delegate_task` on a different provider. Done when every finding has a class and the fixes are pushed.
5. Report in the shape of [assets/report.md](assets/report.md). The merge stays with the human. Done when every finding is in the table.
