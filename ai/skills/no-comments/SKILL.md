---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/no-comments/SKILL.md
name: no-comments
description: Reviews comments and suppressions for durable constraints, removes explanations that duplicate the code, and proposes structural encodings for real constraints.
---

# No Comments

Review the requested files or the current diff. A comment earns its place when
the code cannot express the reason and the reason is stable enough to preserve.

1. Identify comments, suppressions, and warnings in scope.
2. Remove comments that restate the code, narrate mechanics, or preserve a
   workaround that can be deleted.
3. Keep comments that explain an external constraint, a non-obvious invariant,
   or a deliberate tradeoff.
4. For a real recurring constraint, offer a type, test, lint rule, or runtime
   check instead of a comment.
5. Verify that the resulting code still explains its behavior and that tests
   cover the encoded constraint.

Use an independent reviewer when the host supports delegation. Inspect its
findings yourself before applying them.
