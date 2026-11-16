---
name: wizard
description: "Generates an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or CI secrets, walking a third-party dashboard, or running a one-off migration or cutover. Do not use it for steps the agent can perform itself."
---

# Wizard

A wizard is a bash script that walks a human step by step through a manual procedure. It opens URLs, gives exact click and copy instructions, captures values, writes them to `.env` or GitHub secrets, and shows stage N of M. Gate every irreversible stage with `confirm`.

Author it at `.agents/wizards/<slug>.sh`. It never holds a secret value, only the prompts that collect one. Delete it once the procedure is done unless the procedure will run again.

`scripts/template.sh` provides the user experience. Scope the procedure and author the stages below the `STAGES` marker. Do not hand-edit the library above that marker.

## Process

1. Scope. Read the repository, including `.env*`, the README, docker-compose, and `.github/workflows/*`. Every `secrets.*` or `vars.*` is a value the wizard must produce. With no CI, the scoped value table is the source of truth. For a migration, map current to target and name the irreversible acts. Show the ordered stages and the values they produce, then confirm, or record the plan as an assumption when no one answers. Done when every stage is named and every value has a source, a destination, and whether it is secret or public.
2. Map each stage's journey. Give the exact URL, path, or value. Never invent a UI. Read the docs when unsure, and when they are unreachable print the step as unverified in the wizard and flag it in the reply. Done when every stage has a URL, path, or value, or an unverified mark.
3. Author. Copy `scripts/template.sh` and write one `stage` per step in dependency order. Use the helpers `banner`, `stage`, `say`, `step`, `note`, `warn`, `open_url`, `ask`, `ask_secret`, `write_env`, `set_secret`, `set_var`, `pause`, `confirm`, and `finish`. Set `TOTAL_STAGES` before the first `stage`, and keep one focused task per stage. `write_env` warns when the target file is not gitignored, so add `.env` to `.gitignore` first. Done when each scoped stage has a `stage` block.
4. Verify. Run [scripts/verify.sh](scripts/verify.sh) on the wizard: it runs `bash -n` and sets the executable bit. Do not run it end to end, since it waits on browsers and input. Instead trace statically that every captured value lands where it was scoped and that every secret name matches a CI `secrets.*` when CI exists. Done when `verify.sh` passes and the trace finds no unplaced value.
