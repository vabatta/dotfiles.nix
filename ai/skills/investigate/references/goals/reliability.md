# Reliability

**Pick when:** the goal is that it fails less, recovers by itself, or breaks in a way someone notices: crashes, failed runs, silent errors, restarts.

## What to measure
- Failure rate: failed runs over total runs, per job or command, over a stated period.
- Swallowed errors: catch-all handlers, `|| true`, ignored return values, output sent to `/dev/null`.
- Recovery: what happens on retry, restart, or a half-finished run. Does the second run succeed and leave clean state?
- Detection: how long a failure goes unnoticed, and who or what notices it.

## How to measure
- CI history: `gh run list --limit 100 --json name,conclusion,createdAt | fx '.filter(r => r.conclusion == "failure")'`.
- Fix pressure: `git log --since=6.months -i -E --grep='fix|revert|hotfix' --oneline -- <path>`.
- Swallowed errors: `git grep -nIE '\|\| true|2>/dev/null|catch *\(|except *:|_ = ' -- <path>`.
- Recovery: kill the process mid-run, rerun it, and diff the state against a clean run.

## Typical weak spots
Retries without backoff or limits, network and disk calls without timeouts, partial writes without a temp-and-rename, state kept across restarts, and errors logged but not returned.

## Evidence that counts
PROVEN: a failure reproduced on demand, a failure rate counted from run history, or a crash shown by kill-and-rerun. CLAIM: a handler that looks like it swallows errors but was never triggered.
