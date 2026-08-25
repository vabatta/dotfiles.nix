---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/why/SKILL.md
name: why
description: Investigates the evidence behind a design, regression, threshold, or workflow and separates facts from inference.
---

# Why

Use why when the motivation or history matters. Start with the code and Git
history. Search issues, documents, conversations, observability, error reports,
or analytics only when the host provides those sources.

1. State the target and the interpretation of the question.
2. Search source-control history, commits, tests, and code comments.
3. Search each available external source independently.
4. Record empty or unavailable sources as explicit gaps.
5. Cite every claim about intent. Label inference as inference.
6. Return evidence, confidence, gaps, and Preserve, Change, Avoid, and Risk
   constraints when the answer will guide implementation.

Never claim that an external source was searched when the host did not expose
it. Provider-specific query methods belong in optional host references.
