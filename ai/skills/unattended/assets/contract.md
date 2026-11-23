# Run contract: <slug>

| Field | Value |
|---|---|
| Goal | <one sentence> |
| Done | `<command that exits 0>` (also the `/goal` text) |
| Scope | <paths in>. Everything else is out. |
| Cap | <hours, default 8> and <attempts per unit, default 3> |
| Workspace | <worktree path>, branch `<branch>` |
| One-way actions allowed | <default none> |
| Start commit | `<sha>` |

## Delegations

Optional. Each line overrides one row of the decision rights in **build**, in the form `row <n> → <who may now decide, and how>`. Row 8, merge and publish, cannot be delegated. Without this section, every row's absent answer applies as written.

- <for example: row 1 → lead may propose the map on a branch>
