A reviewer has the diff open next to this text. Say what the diff cannot: why the change exists, the shape that makes it easy to read, and the proof that it works. Never list files or retell the diff, and make every claim match it. Drop a section that has nothing to say. When the repo has its own pull request template, fill that one with these sections' content.

```markdown
## Why
<The problem and the intent, in one to three sentences, from the task or the issue. Link the issue. "Improves X" is not a problem.>

## Shape
<The smallest view that makes the change clear: a Mermaid diagram, a call tree, a state machine, or an interface sketch. Leave it out when the diff is already obvious.>

## Evidence
<UI: before and after screenshots. Otherwise the command run on the real artifact and what it showed.>

## Risk
<Easy or hard to undo. What else it can affect. What it deliberately does not touch.>
```
