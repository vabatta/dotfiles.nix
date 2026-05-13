---
name: tickets
description: >
  Use when the user says "ticket", "issue", "board", "backlog", "status",
  "blocked", "depends on", references a ticket number like "#12", or asks
  about work status. Also use proactively: when starting implementation (move
  the ticket to "In progress"), when opening PRs (suggest "Closes #N"), when
  design reveals new needs (suggest sub-issues), when a ticket depends on
  another (add a dependency relationship), or when a feature is done (move to
  "Done"). Trigger whenever GitHub Projects, issue tracking, milestones,
  labels, dependencies, sub-issues, or workflow status boards are relevant —
  even if the user doesn't say "ticket" explicitly.
---

# Ticket Management — GitHub Projects

## The `.ghproject` config file

Every repo (or package directory) keeps a `.ghproject` file that caches project
and field IDs so you don't re-fetch them on every operation. Find the nearest
one by walking up from the relevant package dir; fall back to repo root. If
multiple projects exist and it's unclear which one applies, ask the user.

### Format

```ini
[project]
repo = owner/repo
number = 3
owner = org-or-user
id = PVT_...

[labels]
core
domain-1
blocked
...

[field:Status]
id = PVTSSF_...
Ideas = abc123       # Raw sketch, needs brainstorming
Backlog = def456     # Scoped and ready for work
In progress = ghi789
Done = jkl012
```

Only `SingleSelectField` types get `[field:...]` sections. Comments after `#`
describe what each status means for this project — read them to understand
the workflow before moving tickets. Each project defines its own statuses and
meanings; don't assume a universal set.

### Bootstrapping

If `.ghproject` is missing, build it:

1. `gh project list` → pick the project (ask if ambiguous)
2. `gh project view` → get the project ID
3. `gh project field-list` → get field/option IDs
4. `gh label list` → get available labels

Write the file with inline comments describing each status. If the user hasn't
described them, ask what each status means in their workflow.

If any field or option lookup fails at runtime, silently re-fetch and update
the file.

## Issue relationships

Use GitHub's built-in relationship features to track how issues relate to each
other. Never write "Depends on: #X" in issue bodies or Technical notes — use
the API instead, so relationships are queryable and visible in the project
board.

### Dependencies (blocked by / blocking)

Use when one issue cannot proceed until another is resolved. GitHub supports
two directions: "blocked by" (this issue waits on another) and "blocking"
(this issue is in the way of another). Up to 50 issues per relationship type.

Before advancing a ticket to a new status, query its dependencies. If any
blocker is still open, warn the user — this prevents wasted work.

See `references/github-api.md` → "Dependencies" for the exact endpoints and
`gh` commands.

### Sub-issues (parent / child)

Use when a large feature needs to be broken into smaller tasks. Sub-issues
form a hierarchy (up to 8 levels deep, 100 children per parent). Sub-issues
automatically inherit the parent's Project and Milestone.

Projects can enable "Parent issue" and "Sub-issue progress" fields to
visualize hierarchy and track completion directly on the board.

See `references/github-api.md` → "Sub-issues" for the exact endpoints.

## Moving tickets between statuses

When changing a ticket's status:

1. Read the `.ghproject` comments to understand what the target status means.
2. Query the ticket's dependencies via the blocked_by endpoint. If any
   blocker is still open, warn the user.
3. After the move, suggest what logically comes next based on the status
   comments. Keep it short: one sentence naming the action or skill to run.

## Issue templates

Two templates live in `.github/ISSUE_TEMPLATE/` — read `references/templates.md`
for the full field structure. The raw YAML files are in
`assets/ISSUE_TEMPLATE/` and can be copied directly into a repo.

- **Idea**: lightweight sketch (What / Why / Open questions). Use when an idea
  hasn't been brainstormed or scoped yet.
- **Feature**: structured spec (Context / Approach / Edge cases / Technical
  notes). Use for scoped work ready to enter the pipeline.

When an idea gets brainstormed into a real feature, rewrite its body from idea
format to feature format — the structured fields make downstream work smoother.

Blank issues are disabled, so always use one of these templates.

## Conventions

**Milestones for epics** — use milestones to group related issues into
epics or phases. Never use labels for this; labels serve a different purpose.

**Labels are semantic and flat** — no `prefix:value` patterns like
`area:frontend`. Use categories like Area, Feature, and Workflow. Don't
duplicate information already captured by board fields (e.g., don't create a
"status:done" label when the board has a Done column).

**Titles describe capabilities, not implementations** — write titles as natural
language descriptions of what the user gets. "Pause and resume individual
activities" is clear to anyone; "Implement wf.pause_activity()" belongs in
Technical notes.

**Ask the user when**: multiple projects exist, labels are missing, targets are
ambiguous, or new labels/fields need to be created.

## API reference

For every GitHub API operation this skill needs — issues, projects,
dependencies, sub-issues, issue types, labels, and milestones — read
`references/github-api.md`. It covers both `gh` CLI commands and raw REST/GraphQL
endpoints with step-by-step examples and gotchas.
