---
source: https://github.com/vabatta/dotfiles.nix/blob/main/ai/skills/setup-ai/SKILL.md
name: setup-ai
description: Explains and updates the runtime-owned model preferences used by the shared AI workflow.
---

# Setup AI

The active policy is owned by the runtime at
`$XDG_CONFIG_HOME/ai/model-policy.json`, or at `~/.config/ai/model-policy.json`
when `XDG_CONFIG_HOME` is unset. Nix does not manage that file. The checked-in
`templates/model-policy.json` is only the bootstrap shape used when no runtime
policy exists.

The policy has a default and role preferences for exploration, implementation,
judgment, and prose. Use `inherit` when the host should keep the current
conversation's model.

When changing a preference:

1. Inspect the model identifiers supported by the active host.
2. Read the runtime policy, or copy `templates/model-policy.json` when it does
   not exist, and edit the copy.
3. Run `generate_policy.py` from this skill directory with the edited policy as
   its template.
4. Run `verify_policy.py` against the runtime policy.
5. Read the runtime policy under `XDG_CONFIG_HOME`, or under `~/.config`, and
   confirm the requested values are present.

The generator creates the parent directory and writes stable, sorted JSON. Do
not copy model identifiers from a different client without checking that the
active host accepts them. `inherit` keeps the current conversation's model.
