---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/principle-build-the-lever/SKILL.md
name: principle-build-the-lever
description: "Apply to edits, migrations, analyses, or checks that are more than a couple of obvious changes. Build the tool that does it or proves it (codemod, script, generator, or a skill your subagents follow) instead of working by hand. The tool is the artifact a reviewer can rerun."
---
# Build the Lever

When the work isn't trivial, build the tool that does it instead of doing it by hand.

Before building a lever, apply **principle-use-before-build** and check whether the language, installed dependencies, or project tooling already provides the needed capability.

**Why:** Two payoffs. Throughput: a codemod, generator, or script does the work the same way every time and reruns for free. Confidence: the tool is one artifact a reviewer can read and rerun to check the work. Hand-done changes can only be re-verified by redoing them. A deterministic script turns "trust me" into "run this".

**Pattern:** Default to building the lever. Skip it only when the task is genuinely trivial, a couple of obvious edits you can see at a glance.

- Do the first unit by hand to learn the recipe, then build the tool. Prove it by rerunning it on that unit and diffing against your hand-done version. Make the lever safe to rerun. A reviewer will.
- Codemod or script for edits, generator for repetitive files, a dump-to-sqlite query for analysis, a rerunnable check for verification.
- A deterministic lever beats fan-out. If the tool can process every unit in one pass, run it yourself; don't fan out delegates to hand-apply what a script can do.
- When you fan work out to subagents, write the lever as a skill they all read: the recipe, the verification contract, and the do-not-touch fences in one artifact, so every delegate inherits the same hardened version instead of re-explaining it per prompt and watching each one drift. Keep it outside the delegates' write scope so they can't quietly edit the contract.
- Commit the lever when the work outlives the session, so the next run reruns it instead of redoing it.

**Test:** The diff contains the lever (codemod, script, generator, or delegate skill) and a rerun that reproduces the hand-done unit. If you cited this principle and no such artifact is in the diff, you didn't apply it.

**Balance:** The bar is triviality, not repetition. A one-off still earns a lever when the lever is what makes the work checkable. Per **principle-laziness-protocol**, build the smallest script that does or proves the job, never a framework.

Distinct from **principle-encode-lessons-in-structure**, which makes a recurring instruction a durable guardrail. This is throughput and reviewability on the work in front of you. For scripting the verification itself, see **principle-prove-it-works**.
