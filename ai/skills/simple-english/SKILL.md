---
name: simple-english
description: "Writes or rewrites technical text to the rules of ASD-STE100 Simplified Technical English so it is clear and unambiguous for a non-native reader. Use when rewriting existing text for plain, unambiguous English or STE compliance, on runbooks, procedures, error messages, release notes, incident reports, and API guides. Also use on STE, Simplified Technical English, or ASD-STE100, or for docs that translate well. Not for general tone or document structure."
---

# Simple English: Write Like an Aerospace Manual

Write technical text with the rules of ASD-STE100 Simplified Technical English. The rules exist so that a tired reader who is not a native English speaker cannot misread an instruction.

Write for that tired reader. Each sentence must survive one read.

## Procedure

When asked to write or rewrite technical text:

1. **Select the mode** (pragmatic or strict, below).
2. **Classify each passage** as procedural or descriptive. Every other rule depends on this.
3. **Fix the vocabulary before drafting.** In strict mode, use `make sure that` for the check/verify/confirm/ensure concept — the dictionary rejects all four as verbs. In pragmatic mode, pick one and keep it. Pick ONE noun for config/settings (all are valid technical nouns — pick one and keep it). Use no other word for these concepts in the whole document.
4. **Apply the rules** from [references/rules.md](references/rules.md).
5. **Do the self-check** before delivery. This step is not optional.
6. **Keep code, identifiers, commands, and quoted errors exact** (see Untouchables).

When asked to CHECK text instead of writing it, reply in the shape of [assets/check-report.md](assets/check-report.md). Cite only rule numbers that exist in `references/rules.md`. Do not cite rule numbers from memory: the numbering is unintuitive and models invent it (tested — an agent without this file cited "Rule 3.1: short sentences"; the real Rule 3.1 is about verb forms).

## Two Modes

| Mode | When | Rules applied |
|---|---|---|
| **Pragmatic** (default) | Docs, READMEs, error messages — the user wants clear text | All structural rules. Domain words stay ("idempotent", "webhook"). |
| **Strict** | The user names STE, ASD-STE100, or compliance | Structural rules + the vocabulary guidance in [references/vocabulary.md](references/vocabulary.md). |

## Step 1: Classify the Text

| | Procedural (instructions) | Descriptive (explanations) |
|---|---|---|
| Purpose | Tell the reader what to do | Explain what a thing is or does |
| Verb form | Imperative: "Install the pump." | Simple present/past/future |
| Sentence limit | **20 words** (Rule 5.1) | **25 words** (Rule 6.3) |
| Unit rule | One instruction per sentence (5.2) | One topic per paragraph (6.5), max six sentences per paragraph (6.6) |

Do not mix the two in one passage. A "Getting started" section is procedural. An "Architecture" section is descriptive. A note inside a procedure is descriptive (25-word limit, no imperative).

## Rules and vocabulary

- [references/rules.md](references/rules.md) is the catalog of 53 rules in 9 sections, paraphrased from ASD-STE100 Issue 9. Read it before applying rules, in both modes. It is the only source of rule numbers.
- [references/vocabulary.md](references/vocabulary.md) holds the part-of-speech rulings, the modal ladder, and the consistency lists. Read it for Procedure step 3 and in strict mode.

## Untouchables

These are technical names (Rules 1.5, 8.6). Leave them exact, even when they break vocabulary rules:

- Code blocks, inline code, identifiers, CLI commands, flags, file paths
- Quoted error messages and log lines
- Product names, API endpoint names, config keys
- Numbers with units — each counts as one word in the sentence limit

Facts are untouchable too. Rewrite the style, not the content. When the source does not give a number, a cause, or an exact term, keep the general statement. Do not invent specifics to look concrete.

## Beyond Documentation

Same rules, different targets. Pick the variant for the text and read only that section. Document structure for agent instructions belongs to **writing-for-agents**.

| Variant | Pick when |
|---|---|
| [Error messages and CLI output](references/use-cases.md#error-messages-and-cli-output) | Writing an error, warning, or CLI message |
| [Runbooks and standard operating procedures](references/use-cases.md#runbooks-and-standard-operating-procedures) | Writing steps an operator follows, often under pressure |
| [Incident reports and postmortems](references/use-cases.md#incident-reports-and-postmortems) | Writing up what happened during an outage or incident |
| [Commit messages and PR descriptions](references/use-cases.md#commit-messages-and-pr-descriptions) | Writing a commit message or PR body |
| [API changelogs and release notes](references/use-cases.md#api-changelogs-and-release-notes) | Writing release notes or a changelog entry |
| [Instructions for AI agents (prompts, AGENTS.md, skills)](references/use-cases.md#instructions-for-ai-agents-prompts-agentsmd-skills) | Writing a prompt, AGENTS.md, or skill text an agent executes |
| [Support macros and status-page updates](references/use-cases.md#support-macros-and-status-page-updates) | Writing support replies or status-page updates |
| [Translation and localization prep](references/use-cases.md#translation-and-localization-prep) | The text will be translated or read mostly by non-native readers |
| [UI copy and empty states](references/use-cases.md#ui-copy-and-empty-states) | Writing buttons, labels, empty states, or other UI text |
| [Where STE does not fit](references/use-cases.md#where-ste-does-not-fit) | The text is marketing, brand voice, or persuasion |

## Self-Check Before Delivery

This step is not optional. Run these four checks on the draft:

1. Count words in the three longest sentences. Over the 20/25 limit → split them.
2. Search the draft for: `'ll`, `'re`, `'s` as a contraction (it's, that's; leave possessives to GR-8), `has been`, `have been`, `should`, `-ing` verbs after a comma, semicolons.
3. In procedural text, search for every `if` and `when`. Each one stands at the START of its sentence, before the command. Descriptive sentences may keep `when` after the verb. "Increase the timeout if the network is slow" → "If the network is slow, increase the timeout."
4. Search for the verbs not picked in Procedure step 3 (the check/verify/confirm set). Replace every hit with the chosen verb.

Fix each hit, then deliver. Done when the four checks return no hits. In strict mode, also run `references/checklist.md`.

## Full Example

**Before (real unedited AI output):**

> **Connection timeouts.** If dbsync hangs or fails with `dial tcp: i/o timeout`, check that the host running dbsync can reach the Postgres port (usually 5432) — this is often a security group or firewall rule blocking the connection. If you're connecting to a managed database (RDS, Cloud SQL, etc.), confirm the instance allows connections from dbsync's IP. You can also try increasing `source.connect_timeout_seconds` in your config, since a slow network path can trip the default timeout even when the connection eventually succeeds.

**After (classified procedural, verb = "make sure", conditions first, one instruction per sentence):**

> **Connection timeouts.** dbsync cannot reach the Postgres port (5432 by default). Then it stops with `dial tcp: i/o timeout`.
>
> 1. Make sure that the host that runs dbsync can reach the Postgres port. A firewall or security group usually blocks it.
> 2. If the database is managed (RDS, Cloud SQL), make sure that the instance accepts connections from the IP of dbsync.
> 3. If the network is slow, increase `source.connect_timeout_seconds` in the configuration.

What changed: 40-word sentences split under 20; "you're" expanded; "check/confirm" collapsed to "make sure that"; every condition moved before its command; "etc." removed; code and error strings untouched.

## References

- `references/checklist.md` — full verification pass with searchable patterns, for check mode and final audits
- `references/use-cases.md` — long-form adaptations: error messages, runbooks, incident reports, commits, UI copy, i18n

For the general AI-tell pass, see **unslop**.
