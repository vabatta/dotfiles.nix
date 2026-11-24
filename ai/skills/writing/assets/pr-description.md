A pull request body has two parts, split by a `---` line. Above it is the commit: the title and prose that land in `git log` on squash merge, so no headings, checklists, diagrams, or screenshots there. Below it is for the reviewer only and never reaches history. Leave out the line and everything after it when the reviewer needs nothing more.

Say what the diff cannot: why the change exists, why this approach, and the proof that it works. Never list files or retell the diff, and make every claim match it. State only what the diff, the issue, or the user gave: when a reason, a mechanism, or a detail of the incident is not given, leave it out rather than infer it. Drop a sentence, paragraph, or section that has nothing given to say. When the repo has its own pull request template, fill that one with this content.

Match the title to the repo's convention, read from `git log --oneline` and any commitlint or commitizen config: `type(scope): summary` for Conventional Commits, `scope: summary` when the log uses that, or a bare summary otherwise. The summary itself is an imperative that stands alone.

On squash merge, the commit is the title plus the text above the first `---`: `gh pr merge --squash --subject "<title>" --body-file <file holding that text>`.

```markdown
<Title, such as "fix(fetch): stop retrying POST requests" or "Stop retrying POST requests in the fetch client". Never "Fix bug", "Phase 1", or "Address review".>

<The problem and why it matters now, in one to three sentences. Link the issue, and restate its point so the text does not depend on the link. "Improves X" is not a problem.>

<The approach and why this one: the alternative you rejected, or a known shortcoming. Then the proof worth keeping: the command run on the real artifact and what it showed, a benchmark result.>

---

### Screenshots
<UI: before and after. Leave out for other changes.>

### Review focus
<Where to look hardest, and what feedback you want.>

### Notes
<What this deliberately does not touch, how hard it is to undo, edges not tested, follow-ups, deploy steps.>
```
