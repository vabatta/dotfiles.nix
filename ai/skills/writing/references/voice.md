# Voice pass

The last pass on any prose, and the whole job when the user asks to humanize text, de-slop it, or make it sound less like AI. It removes AI writing patterns and adds a human voice.

## Process

1. Scan for the patterns in [voice-patterns.md](voice-patterns.md).
2. Rewrite. Preserve meaning, match intended tone. When a fix needs a fact (mechanism, number, source), look it up in the code or sources. If it cannot be found, cut the sentence instead of inventing a fact.
3. Add soul (see next section), only to narrative prose. For reference docs, READMEs, logs, and specs, remove patterns and apply rule 27 (say what it does) only.
4. Self-audit: "What makes this obviously AI generated?" Fix remaining tells. Done when a fresh read finds no pattern from the list.

Leave code, identifiers, paths, numeric ranges, and verbatim quotes untouched. Patterns apply to the prose around them.

## Adding soul

Removing patterns is half the job.

- **Have opinions.** React to facts instead of neutrally listing pros and cons.
- **Acknowledge complexity.** "Impressive but also kind of unsettling" beats "impressive."
- **Use "I" when it fits.** First person isn't unprofessional.
- **Be specific.** Not "this is concerning" but "there's something unsettling about agents churning away at 3am."

## Patterns

The catalog of 31 numbered patterns and the slop-to-simple substitution table is in [voice-patterns.md](voice-patterns.md). Read it before step 1 of every pass.
