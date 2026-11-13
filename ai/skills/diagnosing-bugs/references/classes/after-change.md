# Broke after a change

**Pick when:** it worked before a known event: an upgrade, a dependency bump, a merged branch, a config or infrastructure change.

## Build the loop
- Write a script that exits 0 on good and 1 on bad, using the symptom check. Exit 125 when a commit cannot be tested (it does not build).
- Find a good and a bad point: a tag, a commit, or two lockfiles.
- Run `git bisect start <bad> <good>`, then `git bisect run ./check.sh`, then `git bisect reset`.

## Narrow it
- For a dependency bump, bisect the dependency, not your repo: pin versions between the old and new one, or read its changelog for the range.
- For a lockfile change, diff the resolved versions and test each changed package alone.
- For config or infrastructure, diff the effective config (rendered, not the template) between the good and bad environment.

## Typical root causes
A changed default in a new version, a removed or renamed API, a transitive dependency that moved, a config key renamed, a migration that did not run.

## Proof of fix
The bisect check script passes at the fixed commit, and a test pins the behaviour the change broke.
