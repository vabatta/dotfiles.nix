---
name: principle-migrate-callers-then-delete-legacy-apis
description: "Apply when replacing an existing internal API that still has callers. Migrate every caller and delete the old API in the same change."
---

# Migrate Callers Then Delete Legacy APIs

Once a new API is the right design, migrate its callers and remove the old API in the same change.

**Why:** Keeping both APIs creates dual-path complexity and makes the codebase append-only. Compatibility layers meant to be temporary become permanent architecture.

**Pattern:**
- Apply when no external user depends on backward compatibility.
- Inventory the callers, migrate them, and delete the old API immediately.
- A temporary adapter is an exception: name what removes it and list it in the report.
- Update tests to assert the new contract, and delete tests that only protect pre-refactor implementation details.

**Test:** `git grep` for the old symbol and its string name across code, tests, docs, and config in the working tree finds zero references, and the old symbol no longer exists. A surviving adapter or deprecated shim means the change is incomplete, unless it is the one listed exception whose remover is named.
