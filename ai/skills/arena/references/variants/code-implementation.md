# Code implementation

**Pick when:** the interface is fixed and the candidates are working code behind it, so running them is cheaper than arguing.

- **Candidate:** a full implementation that passes the shared tests.
- **Location:** each writer on its own branch `arena/<slug>/N` in its own checkout. Use the harness's isolated checkout where it has one, otherwise `git worktree add`.
- **Before fanning out:** write the shared tests at the interface in the base checkout, so every candidate starts from them and is judged on the same red tests.
- **Default rubric:** shared tests pass, net added lines, measured speed or resource use when it matters, and how readable the code is to someone new.
- **Verify:** run the shared tests and any benchmark on the synthesized branch, and quote the output.
- **Return:** the name of the synthesized branch. Arena does not merge it.
