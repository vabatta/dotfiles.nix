# Controlled

**Pick when:** the text must survive a tired or non-native reader with no second reading: runbooks, procedures, error messages, release notes, incident reports, API guides, text for translation, or when the user names STE, Simplified Technical English, or ASD-STE100, or asks to check text for compliance.

Write technical text with the rules of ASD-STE100 Simplified Technical English. The rules exist so that a tired reader who is not a native English speaker cannot misread an instruction.

Write for that tired reader. Each sentence must survive one read.

## Procedure

When asked to write or rewrite technical text:

1. **Select the mode** (pragmatic or strict, below).
2. **Classify each passage** as procedural or descriptive. Every other rule depends on this.
3. **Fix the vocabulary before drafting.** In strict mode, use `make sure that` for the check/verify/confirm/ensure concept — the dictionary rejects all four as verbs. In pragmatic mode, pick one and keep it. Pick one noun for config/settings (all are valid technical nouns). Use no other word for these concepts in the whole document, because a reader of controlled English takes a second word to mean a second thing.
4. **Apply the rules** from [../ste-rules.md](../ste-rules.md).
5. **Do the self-check** before delivery, because drafting breaks the rules in ways the eye does not catch and the checks do.
6. **Keep code, identifiers, commands, and quoted errors exact** (see Untouchables).

When asked to CHECK text instead of writing it, reply in the shape of [ste-check-report.md](../../assets/ste-check-report.md). Cite only rule numbers that exist in `ste-rules.md`. Do not cite rule numbers from memory: the numbering is unintuitive and models invent it (tested — an agent without this file cited "Rule 3.1: short sentences"; the real Rule 3.1 is about verb forms).

## Two Modes

| Mode | When | Rules applied |
|---|---|---|
| **Pragmatic** (default) | Docs, READMEs, error messages — the user wants clear text | All structural rules. Domain words stay ("idempotent", "webhook"). |
| **Strict** | The user names STE, ASD-STE100, or compliance | Structural rules + the vocabulary guidance in [../ste-vocabulary.md](../ste-vocabulary.md). |

## Step 1: Classify the Text

| | Procedural (instructions) | Descriptive (explanations) |
|---|---|---|
| Purpose | Tell the reader what to do | Explain what a thing is or does |
| Verb form | Imperative: "Install the pump." | Simple present/past/future |
| Sentence limit | **20 words** (Rule 5.1) | **25 words** (Rule 6.3) |
| Unit rule | One instruction per sentence (5.2) | One topic per paragraph (6.5), max six sentences per paragraph (6.6) |

Do not mix the two in one passage. A "Getting started" section is procedural. An "Architecture" section is descriptive. A note inside a procedure is descriptive (25-word limit, no imperative).

## Rules and vocabulary

- [../ste-rules.md](../ste-rules.md) is the catalog of 53 rules in 9 sections, paraphrased from ASD-STE100 Issue 9. Read it before applying rules, in both modes. It is the only source of rule numbers.
- [../ste-vocabulary.md](../ste-vocabulary.md) holds the part-of-speech rulings, the modal ladder, and the consistency lists. Read it for Procedure step 3 and in strict mode.

## Untouchables

These are technical names (Rules 1.5, 8.6). Leave them exact, even when they break vocabulary rules:

- Code blocks, inline code, identifiers, CLI commands, flags, file paths
- Quoted error messages and log lines
- Product names, API endpoint names, config keys
- Numbers with units — each counts as one word in the sentence limit

Facts are untouchable too. Rewrite the style, not the content. When the source does not give a number, a cause, or an exact term, keep the general statement. Do not invent specifics to look concrete.

## Beyond Documentation

Same rules, different targets. Pick the case for the text and read only that section. Document structure for agent instructions is the agents variant.

| Case | Pick when |
|---|---|
| [Error messages and CLI output](../ste-use-cases.md#error-messages-and-cli-output) | Writing an error, warning, or CLI message |
| [Runbooks and standard operating procedures](../ste-use-cases.md#runbooks-and-standard-operating-procedures) | Writing steps an operator follows, often under pressure |
| [Incident reports and postmortems](../ste-use-cases.md#incident-reports-and-postmortems) | Writing up what happened during an outage or incident |
| [Commit messages and PR descriptions](../ste-use-cases.md#commit-messages-and-pr-descriptions) | Writing a commit message or PR body |
| [API changelogs and release notes](../ste-use-cases.md#api-changelogs-and-release-notes) | Writing release notes or a changelog entry |
| [Instructions for AI agents (prompts, AGENTS.md, skills)](../ste-use-cases.md#instructions-for-ai-agents-prompts-agentsmd-skills) | Writing a prompt, AGENTS.md, or skill text an agent executes |
| [Support macros and status-page updates](../ste-use-cases.md#support-macros-and-status-page-updates) | Writing support replies or status-page updates |
| [Translation and localization prep](../ste-use-cases.md#translation-and-localization-prep) | The text will be translated or read mostly by non-native readers |
| [UI copy and empty states](../ste-use-cases.md#ui-copy-and-empty-states) | Writing buttons, labels, empty states, or other UI text |
| [Where STE does not fit](../ste-use-cases.md#where-ste-does-not-fit) | The text is marketing, brand voice, or persuasion |

## Self-Check Before Delivery

Run these four checks on the draft:

1. Count words in the three longest sentences. Over the 20/25 limit → split them.
2. Search the draft for: `'ll`, `'re`, `'s` as a contraction (it's, that's; leave possessives to GR-8), `has been`, `have been`, `should`, `-ing` verbs after a comma, semicolons.
3. In procedural text, search for every `if` and `when`. Each one stands at the START of its sentence, before the command. Descriptive sentences may keep `when` after the verb. "Increase the timeout if the network is slow" → "If the network is slow, increase the timeout."
4. Search for the verbs not picked in Procedure step 3 (the check/verify/confirm set). Replace every hit with the chosen verb.

Fix each hit, then deliver. Done when the four checks return no hits. In strict mode, also run `../ste-checklist.md`.

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
