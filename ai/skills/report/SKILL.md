---
name: report
description: "Renders any result worth scanning, such as a summary, answer, verdict, findings, comparison, status, or plan, as a page with status chips, grouped rows, and inline SVG diagrams, or as terminal markdown when no HTML view exists. Use when asked for a report, a summary, a recap, a page, an HTML view, or something easier to scan, or when a finished result is ready to show."
---

# Report

Any result, shown in the richest form the host can display: a session recap, a comparison, a status, an explanation, or the output of another skill. When the content arrives as a filled template, its fields map to blocks. Otherwise map the content directly. This skill decides only the form, never the content.

## Pick a renderer

Read only the chosen variant.

| Variant | Pick when |
|---|---|
| [HTML](references/renderers.md#html) | A tool that shows an HTML page inline is present, or the user asked for a page. |
| [Markdown](references/renderers.md#markdown) | No such tool is present and no page was asked for. |

Decide by the tools in this session, not by the harness name. One session can run under more than one harness.

## Map the content

Map each part of the content to a block. A block that has no content is left out.

| Content | Block |
|---|---|
| The answer or verdict, one to three sentences | lead |
| Date, subject, and pinned versions | meta |
| One item per line, each with an action or state | rows |
| Items sorted into two to four buckets | groups |
| Relations between items, a flow, or a before and after | figure |
| Claims with a tier and a source | evidence |
| Questions only the user can settle | decide |
| The next skill to run | next |

Use one status word per chip, from this fixed set:

| Chip | Meaning | Glyph |
|---|---|---|
| `ok` | sourced, done, keep, passing | ● |
| `wn` | secondary, partial, user only, needs care | ▲ |
| `rk` | unverified, off, failing, blocked | ■ |
| `in` | neutral information, a rule, a reference | ◆ |

Done when every part of the content has a block or is left out because it is empty.

## Write

- Start with the answer. Put no heading, title banner, or intro above the lead, because the reader scans the first line and decides from it.
- Each row holds one item. Name the item, give the reason in a few words, and end with one chip.
- Move the evidence below the answer, so it is there for the reader who doubts and out of the way for the one who does not. In HTML, fold it into a `details` block whose summary counts each tier.
- Give a status as a chip. Do not spell a tier in capitals inside prose, since the chip already carries it and capitals in prose read as shouting.
- Draw a figure only when the relations matter. Prose that explains the figure means the figure needs to be redrawn.

Done when the rendered result follows the chosen variant and its check passes.
