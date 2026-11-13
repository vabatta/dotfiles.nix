Frame, step 1, one message:

```text
Stack: <existing capability used: stdlib, installed dependency, project API>
Budget: <N> net added source lines (<given by user | estimate>)
Check: <failing test or command> → passes when <expected result>
```

Result, the reply after steps 5 to 7:

```text
Result: <done | partial: what is left>
Check: <command> → <pass, quoted>
Real run: <command on the real artifact> → <value read>
Lines: <net> net against a budget of <N> (added <a>, deleted <d>)
Removed: <what was deleted first, or "nothing needed removing">
Assumptions: <each answer written down instead of asked, or "none">
```
