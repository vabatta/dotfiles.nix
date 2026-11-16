Frame, step 1, one message:

```text
Acceptance: <line in the user's words>; <line>
Task: <trivial | bug | feature | refactor | dependency | docs> · Language: <go | typescript | python | none>
Stack: <existing capability used: stdlib, installed dependency, project API>
Budget: <N> net added source lines (<given by user | estimate>)
Check: <failing test or command> → passes when <expected result>
```

Result, the reply after step 8:

```text
Result: <done | partial: what is left>
Check: <command> → <pass, quoted>
Real run: <command on the real artifact> → <value read>
Lines: <net> net against a budget of <N> (added <a>, deleted <d>)
Removed: <what was deleted first, or "nothing needed removing">
Review: <converged | not converged | capped | skipped by request> · see the review report
Held back: <scope not in the acceptance lines, or "nothing">
Rulings: <each choice made without asking, why, cost if wrong, or "none">
Delivered: <what the task asked for: commit, PR link, or "nothing asked">
```
