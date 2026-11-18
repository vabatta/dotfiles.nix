# Run while you are away

**Pick when:** the work is long, overnight, scheduled, or started by a webhook, and no one will answer questions.
**Chain:** unattended, figure-it-out
**Done looks like:** the contract's done command exits 0, or the cap is reached with every unit landed or parked.

## Steps
1. **unattended**. Write the contract: goal, done command, scope, cap, workspace, one-way actions allowed, start commit.
2. For each unit, pick its own playbook and run it with the gates. The contract answers every question: product decisions become assumptions, a one-way door stops the unit.
3. Report with the unattended report, led by the done command's result.

## Watch for
- A done condition that cannot be checked by a command: fix the contract before starting.
- Gates that fire on every unit, such as arena: the cap pays for them, so say in the plan which units get them.
