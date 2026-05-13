# GitHub API Reference

Every API operation this skill needs, organized by category. Each operation
lists the `gh` CLI command first (preferred), then the raw REST/GraphQL
endpoint for cases where `gh` doesn't support it.

API version: `2026-03-10`. Always pass `-H "X-GitHub-Api-Version: 2026-03-10"`
on raw API calls.

## Table of contents

1. Issues
2. Dependencies
3. Sub-issues
4. Projects
5. Issue types
6. Labels
7. Milestones

---

## 1. Issues

### Create an issue

```bash
gh issue create --repo OWNER/REPO \
  --title "Title here" \
  --body "Body here" \
  --label "frontend" \
  --milestone "v1.0" \
  --assignee "username"
```

To create from a template, use `--template "Feature"` (matches the template
name in `.github/ISSUE_TEMPLATE/`).

### Read an issue

```bash
gh issue view ISSUE_NUMBER --repo OWNER/REPO --json id,nodeId,title,body,state,labels,milestone,assignees
```

**Important ID distinction:**
- `id` = internal database ID (integer, e.g. `3000028010`). Used by the
  dependencies REST API.
- `nodeId` = GraphQL node ID (string, e.g. `I_kwDOOakzpM6yyU6H`). Used by
  sub-issues GraphQL API.
- `number` = the human-visible issue number (e.g. `42`). Used in URLs and
  most `gh` commands.

### Update an issue

```bash
gh issue edit ISSUE_NUMBER --repo OWNER/REPO \
  --title "New title" \
  --body "New body" \
  --add-label "backend" \
  --remove-label "frontend" \
  --milestone "v2.0"
```

### Close / reopen

```bash
gh issue close ISSUE_NUMBER --repo OWNER/REPO --reason "completed"
gh issue reopen ISSUE_NUMBER --repo OWNER/REPO
```

---

## 2. Dependencies

Dependencies track "blocked by" and "blocking" relationships between issues.
These are GitHub's native feature — use them instead of writing "Depends on"
in issue bodies.

**Limit:** 50 issues per relationship type per issue.

**Critical:** The dependencies REST API uses the issue's **database ID**
(the integer `id` field), not the issue number. Always fetch it first.

### Get the database ID of an issue

```bash
gh api /repos/OWNER/REPO/issues/ISSUE_NUMBER --jq '.id'
```

This returns an integer like `3000028010`.

### List what blocks an issue

```bash
gh api /repos/OWNER/REPO/issues/ISSUE_NUMBER/dependencies/blocked_by
```

Returns an array of issue objects that block this issue.

### Add a "blocked by" dependency

Step 1 — get the database ID of the **blocker** issue:

```bash
BLOCKER_DB_ID=$(gh api /repos/OWNER/REPO/issues/BLOCKER_NUMBER --jq '.id')
```

Step 2 — add the dependency to the **blocked** issue:

```bash
gh api --method POST \
  /repos/OWNER/REPO/issues/BLOCKED_NUMBER/dependencies/blocked_by \
  -f "issue_id=$BLOCKER_DB_ID"
```

**Example:** Issue #5 is blocked by issue #3:

```bash
BLOCKER_DB_ID=$(gh api /repos/acme/app/issues/3 --jq '.id')
gh api --method POST \
  /repos/acme/app/issues/5/dependencies/blocked_by \
  -f "issue_id=$BLOCKER_DB_ID"
```

### Remove a "blocked by" dependency

```bash
gh api --method DELETE \
  /repos/OWNER/REPO/issues/BLOCKED_NUMBER/dependencies/blocked_by/BLOCKER_DB_ID
```

### List what an issue is blocking

```bash
gh api /repos/OWNER/REPO/issues/ISSUE_NUMBER/dependencies/blocking
```

Returns an array of issue objects that this issue blocks.

### Check dependencies before moving a ticket

Before advancing a ticket to a new status, run this check:

```bash
BLOCKERS=$(gh api /repos/OWNER/REPO/issues/ISSUE_NUMBER/dependencies/blocked_by \
  --jq '[.[] | select(.state == "open")] | length')

if [ "$BLOCKERS" -gt 0 ]; then
  echo "WARNING: $BLOCKERS open blockers remain"
  gh api /repos/OWNER/REPO/issues/ISSUE_NUMBER/dependencies/blocked_by \
    --jq '.[] | select(.state == "open") | "#\(.number) \(.title)"'
fi
```

---

## 3. Sub-issues

Sub-issues create parent/child hierarchies. Up to 100 children per parent,
8 levels of nesting. Children inherit the parent's Project and Milestone.

### List sub-issues of a parent

```bash
gh api /repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues
```

Returns an array of child issue objects.

### Get the parent of an issue

```bash
gh api /repos/OWNER/REPO/issues/CHILD_NUMBER/parent
```

Returns the parent issue object, or 404 if none.

### Add a sub-issue (REST)

Step 1 — get the **database ID** of the child issue:

```bash
CHILD_DB_ID=$(gh api /repos/OWNER/REPO/issues/CHILD_NUMBER --jq '.id')
```

Step 2 — add it as a sub-issue of the parent:

```bash
gh api --method POST \
  /repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues \
  -f "sub_issue_id=$CHILD_DB_ID"
```

### Add a sub-issue (GraphQL)

Use this when the REST endpoint isn't available or you need cross-repo support.
Requires **node IDs** (not database IDs) and a feature header.

Step 1 — get node IDs:

```bash
PARENT_NODE_ID=$(gh issue view PARENT_NUMBER --repo OWNER/REPO --json nodeId --jq '.nodeId')
CHILD_NODE_ID=$(gh issue view CHILD_NUMBER --repo OWNER/REPO --json nodeId --jq '.nodeId')
```

Step 2 — add the sub-issue:

```bash
gh api graphql -H 'GraphQL-Features: sub_issues' -f query="
  mutation {
    addSubIssue(input: {
      issueId: \"$PARENT_NODE_ID\",
      subIssueId: \"$CHILD_NODE_ID\"
    }) {
      issue { title }
      subIssue { title }
    }
  }"
```

### Remove a sub-issue

```bash
CHILD_DB_ID=$(gh api /repos/OWNER/REPO/issues/CHILD_NUMBER --jq '.id')
gh api --method DELETE \
  /repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issue \
  -f "sub_issue_id=$CHILD_DB_ID"
```

### Reprioritize a sub-issue

Move a child to a different position in the parent's sub-issue list:

```bash
CHILD_DB_ID=$(gh api /repos/OWNER/REPO/issues/CHILD_NUMBER --jq '.id')
AFTER_DB_ID=$(gh api /repos/OWNER/REPO/issues/AFTER_NUMBER --jq '.id')

gh api --method PATCH \
  /repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues/priority \
  -f "sub_issue_id=$CHILD_DB_ID" \
  -f "after_id=$AFTER_DB_ID"
```

Omit `after_id` to move to the top of the list.

---

## 4. Projects

### List projects

```bash
gh project list --owner OWNER
```

### View a project (get ID and metadata)

```bash
gh project view PROJECT_NUMBER --owner OWNER --format json
```

### List fields and their options

```bash
gh project field-list PROJECT_NUMBER --owner OWNER --format json
```

For single-select fields (like Status), the response includes each option's
`id` and `name`. These option IDs go into the `.ghproject` file.

### Add an issue to a project

**Items must be added to the project before any field can be set.**

```bash
ITEM_ID=$(gh project item-add PROJECT_NUMBER \
  --owner OWNER \
  --url "https://github.com/OWNER/REPO/issues/ISSUE_NUMBER" \
  --format json --jq '.id')
```

Save `ITEM_ID` — you need it for all subsequent field updates. This is a
project-item ID, different from the issue number or database ID.

### Set a single-select field (e.g. Status)

```bash
gh project item-edit \
  --project-id PROJECT_ID \
  --id ITEM_ID \
  --field-id FIELD_ID \
  --single-select-option-id OPTION_ID
```

Get `PROJECT_ID`, `FIELD_ID`, and `OPTION_ID` from the `.ghproject` file.

**Example:** Move issue to "In progress":

```bash
gh project item-edit \
  --project-id PVT_abc123 \
  --id PVTI_xyz789 \
  --field-id PVTSSF_def456 \
  --single-select-option-id ghi789
```

### Update field options (DANGER)

`updateProjectV2Field` via GraphQL replaces **all** options atomically.
If you omit an existing option, it gets deleted — and every item using that
option silently loses its status.

When adding or renaming a status option:

1. Fetch all current options via `gh project field-list`
2. Include **every** existing option in the mutation alongside your changes
3. After the mutation, verify items whose option IDs may have changed

### Projects REST API (alternative to GraphQL)

GitHub now also has a REST API for Projects (as of September 2025):

```bash
# List project items
gh api /orgs/OWNER/projects/PROJECT_NUMBER/items

# List project fields
gh api /orgs/OWNER/projects/PROJECT_NUMBER/fields

# Update a project item field
gh api --method PATCH \
  /orgs/OWNER/projects/PROJECT_NUMBER/items/ITEM_ID \
  --input - <<EOF
{
  "fields": [
    { "id": FIELD_ID_INT, "value": "OPTION_ID_STRING" }
  ]
}
EOF
```

These endpoints work for organization-owned projects. For user-owned projects,
replace `/orgs/OWNER/` with `/users/USER_ID/` and `projects` with `projectsV2`.

---

## 5. Issue types

Issue types (Task, Bug, Epic, etc.) are organization-level. Use them to
categorize issues beyond labels.

### List issue types for an org

```bash
gh api /orgs/ORG/issue-types
```

Returns an array like:

```json
[
  { "id": 410, "node_id": "IT_kwDNAd3NAZo", "name": "Task" },
  { "id": 411, "node_id": "IT_kwDNAd3NAZs", "name": "Bug" }
]
```

### Create an issue type

```bash
gh api --method POST /orgs/ORG/issue-types \
  -f name="Epic" \
  -f description="Multi-week tracking of work" \
  -F is_enabled=true \
  -f color="green"
```

### Update an issue type

```bash
gh api --method PUT /orgs/ORG/issue-types/ISSUE_TYPE_ID \
  -f name="Epic" \
  -f description="Updated description" \
  -F is_enabled=true \
  -f color="blue"
```

### Delete an issue type

```bash
gh api --method DELETE /orgs/ORG/issue-types/ISSUE_TYPE_ID
```

### Set an issue's type (GraphQL)

```bash
ISSUE_NODE_ID=$(gh issue view ISSUE_NUMBER --repo OWNER/REPO --json nodeId --jq '.nodeId')

gh api graphql -f query="
  mutation {
    updateIssueIssueType(input: {
      issueId: \"$ISSUE_NODE_ID\",
      issueTypeId: \"ISSUE_TYPE_NODE_ID\"
    }) {
      issue { title }
    }
  }"
```

---

## 6. Labels

### List labels

```bash
gh label list --repo OWNER/REPO
```

### Create a label

```bash
gh label create "area-frontend" \
  --repo OWNER/REPO \
  --color "0075ca" \
  --description "Frontend work"
```

### Add / remove labels on an issue

```bash
gh issue edit ISSUE_NUMBER --repo OWNER/REPO \
  --add-label "area-frontend" \
  --remove-label "area-backend"
```

---

## 7. Milestones

### List milestones

```bash
gh api /repos/OWNER/REPO/milestones --jq '.[] | {number, title, state, due_on}'
```

### Create a milestone

```bash
gh api --method POST /repos/OWNER/REPO/milestones \
  -f title="v2.0" \
  -f description="Second release" \
  -f due_on="2026-06-01T00:00:00Z"
```

### Assign a milestone to an issue

```bash
MILESTONE_NUMBER=$(gh api /repos/OWNER/REPO/milestones \
  --jq '.[] | select(.title == "v2.0") | .number')

gh issue edit ISSUE_NUMBER --repo OWNER/REPO --milestone "v2.0"
```

---

## ID cheat sheet

Different APIs need different identifiers for the same issue. Getting
them mixed up is the #1 source of silent failures.

| ID type          | Looks like           | How to get it                                | Used by                    |
|-----------------|---------------------|----------------------------------------------|---------------------------|
| Issue number     | `42`                | URL, `gh issue list`                         | `gh issue` commands, URLs |
| Database ID      | `3000028010`        | `gh api /repos/O/R/issues/42 --jq '.id'`    | Dependencies REST, sub-issues REST |
| Node ID          | `I_kwDOOakz...`     | `gh issue view 42 --json nodeId --jq '.nodeId'` | Sub-issues GraphQL, issue types GraphQL |
| Project item ID  | `PVTI_lADO...`      | `gh project item-add ... --jq '.id'`         | `gh project item-edit`    |
| Field ID         | `PVTSSF_lADO...`    | `gh project field-list`, `.ghproject` file    | `gh project item-edit`    |
| Option ID        | `f75ad846`          | `gh project field-list`, `.ghproject` file    | `gh project item-edit --single-select-option-id` |
