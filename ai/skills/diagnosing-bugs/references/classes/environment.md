# Environment-only

**Pick when:** it works in one place and fails in another: local and CI, macOS and Linux, one machine, staging and production.

## Build the loop
- Reproduce in the failing environment first: run the CI job locally, or the command over ssh on the failing host. A loop on the passing side cannot go red.
- When that is impossible, build a loop that captures the difference: a script that prints the environment facts (versions, variables, paths, locale, architecture, limits) on both sides.
- Make it portable: commands and flags both BSD and GNU tools accept.

## Narrow it
- Diff the two environment reports and change one difference at a time on the passing side until it fails.
- Check the usual splits: case-sensitive filesystem, path separators and lengths, line endings, `sed` and `grep` flag differences, missing tools, timezone and locale, CPU architecture, memory and file limits.
- For production only, compare config, data volume, and concurrency before suspecting code.

## Typical root causes
A tool or version present on one side only, an unset variable, a case or path difference, a GNU-only or BSD-only flag, a resource limit, data that only exists in production.

## Proof of fix
The command passes in the environment that failed, and the difference is pinned in setup (a Nix package, a CI step, a check) rather than worked around.
