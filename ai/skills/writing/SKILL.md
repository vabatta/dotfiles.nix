---
name: writing
description: "Writes and rewrites prose for the reader who will read it, picking the rules by that reader. People get docs structured by document type and worded for a tired engineer, agents get skills and prompts that trigger and run predictably, and non-native or regulated readers get ASD-STE100 Simplified Technical English. Every pass ends by removing AI writing tells. Use when writing or editing a README, tutorial, how-to, design doc, RFC, docs page, runbook, error message, release note, incident report, PR description, or commit message, when tightening a skill, AGENTS.md, CLAUDE.md, or prompt, when checking text for STE compliance, or when asked to humanize text, de-slop it, or make it sound less like AI, even when they only say write this up or make this clearer. Not for restating the last chat message, and not for rendering results as a page."
---

# Writing

Write for the one reader who will read the text, because every rule here exists to stop that reader from misreading it. The reader decides the variant. The voice pass runs last on everything.

## Pick the variant

Read only the chosen variant. When a text has two readers, such as a runbook that a person follows and an agent executes, write for the stricter one, which is the controlled variant.

| Variant | Pick when |
|---|---|
| [people](references/variants/people.md) | A person reads it: docs, README, tutorial, how-to, design doc, RFC, PR description, commit message |
| [agents](references/variants/agents.md) | An agent reads it: a skill, AGENTS.md, CLAUDE.md, a system prompt, or a file a skill points to |
| [controlled](references/variants/controlled.md) | A tired or non-native reader must not misread it: runbooks, procedures, error messages, release notes, incident reports, translation, or the user names STE or asks for a compliance check |

When the user only asks to humanize or de-slop existing text, skip the variants and run the voice pass alone. Done when the variant, or the voice pass alone, is named.

## Rules for every variant

- **When a rule makes a sentence worse, fix the sentence another way or leave it alone.** The rules serve the reader. A sentence that follows every rule and sounds like a machine wrote it has failed.
- **The codebase is the word list.** Write the real symbol, file, flag, or command name, not a synonym or a description of it, so the reader can search for it.
- **Facts are fixed.** Rewrite the style, never the content. When a fix needs a number, a cause, or a source that is not there, look it up, or keep the general statement. An invented specific is worse than a vague true one.
- **Leave code, identifiers, commands, paths, and quoted errors exact.** They are names, not prose.

## Steps

1. Write or rewrite with the chosen variant. Done when its own steps or checks are done.
2. Run the [voice pass](references/voice.md) as the last pass, after the variant's rules, so nothing reintroduces a pattern it removed. Done when a fresh read finds no pattern from its catalog.
3. Reply with the text. In a check request, reply in the variant's report shape instead. Done when the reply holds only the text or the report, with no account of the passes run.

## References

Each variant names the files it needs. All of them live here.

- [voice.md](references/voice.md) and [voice-patterns.md](references/voice-patterns.md): the voice pass and its catalog of 31 AI patterns. Read both for step 2.
- [diataxis-modes.md](references/diataxis-modes.md): the four document modes. Read the picked mode's section in the people variant.
- [doc-review.md](references/doc-review.md): the people variant's review checklist and a worked before-and-after example.
- [skill-mechanics.md](references/skill-mechanics.md): invocation, splitting, and routers. Read it in the agents variant when the document is a skill.
- [ste-rules.md](references/ste-rules.md): the 53 STE rules, the only source of rule numbers. Read it in the controlled variant before applying or citing a rule.
- [ste-vocabulary.md](references/ste-vocabulary.md), [ste-checklist.md](references/ste-checklist.md), and [ste-use-cases.md](references/ste-use-cases.md): the controlled variant's vocabulary rulings, strict-mode checklist, and per-text cases.
- [assets/pr-description.md](assets/pr-description.md) and [assets/ste-check-report.md](assets/ste-check-report.md): the PR body shape and the STE check report shape.

If another skill called this one, return to its next step. This return ends the skill, not the turn.
