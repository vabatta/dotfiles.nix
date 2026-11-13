# Fix a hard bug

**Pick when:** something fails and the cause is unknown: an error, a flaky test, a regression, something slow.
**Chain:** diagnosing-bugs, build, review
**Journey:** yes
**Done looks like:** the original repro no longer fails, a regression test guards it, and the PR is reviewed.

## Steps
1. **diagnosing-bugs**. Hand it the symptom and how to reproduce it. Out: a loop that fails on demand, the root cause, and the fix site.
2. Gates from `references/gates.md`: decide runs when the root cause allows more than one fix, design when the fix changes an interface.
3. **build**. Turn the repro into the regression test, then fix at the root. Out: red then green, with the real run.
4. **review**.

## Watch for
- A guard that hides the symptom is not a fix.
- A root cause in another subsystem or repo: re-frame it as its own unit.
- A cause that is already known: this is change-code, not this playbook.
