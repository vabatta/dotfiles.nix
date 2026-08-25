---
source: https://github.com/cursor/plugins/blob/51a96e0dd838404da19ba83dc70aa21eef71f868/pstack/skills/poteto-mode/SKILL.md
name: poteto-mode
description: Applies a rigorous, concise engineering workflow to non-trivial implementation, investigation, design, review, and verification work.
---

# Poteto Mode

Use this mode for work that needs more than a small direct edit.

Read a leaf principle in full before applying it.

When delegating, read `ai/model-policy.json` under `XDG_CONFIG_HOME` when that
variable is set, or under `~/.config` otherwise. Treat its values as preferences
for the host's delegation mechanism. `inherit` means use the current
conversation's model. Never invent a model identifier.

## Workflow

1. Inspect the repository, current changes, and relevant runtime behavior.
2. State the task boundary and the observable definition of done.
3. Choose the smallest matching workflow.
4. Model the important data shape before adding branching logic.
5. Design before coding when the shape is uncertain.
6. Make one coherent change at a time.
7. Verify each unit against the real artifact before starting the next.
8. Review the final diff for unrelated changes and unsupported assumptions.

## Routing

- Runtime or architecture explanation: `how`, `why`, or `teach`.
- Design uncertainty: `architect` and, when useful, `arena`.
- Team discussion: `team-discussion` for structured perspectives and rebuttal.
- Large or multi-phase work: `figure-it-out`.
- Debugging or regression work: `blast-radius`, `principle-fix-root-causes`,
  and `principle-prove-it-works`.
- Adversarial review: `interrogate`.
- Comment and explanation review: `no-comments`, `technical-writing`, and
  `unslop`.
- Multi-step or unattended work: `show-me-your-work`.
- Learning from completed work: `reflect`.
- Model preferences: `setup-ai`.

Apply only the principles that change a concrete decision. Common choices are
`principle-laziness-protocol`, `principle-boundary-discipline`,
`principle-model-the-domain`, `principle-sequence-verifiable-units`, and
`principle-prove-it-works`. Before adding custom code or a wrapper, apply
`principle-use-before-build`.

## Delegation

Delegate only when it reduces risk or provides independent coverage. Give each
writer an isolated output location. Prefer a separate reviewer for verification.
Inspect the resulting artifact yourself. Treat an agent's report as a pointer,
not as proof.

If the host cannot delegate, perform the work directly and preserve the same
brief, evidence, and verification requirements.

## Human Decisions

Do not ask the human to choose between options that can be settled by inspecting
the repository or running a probe. Ask only for product intent, irreversible
actions, or preferences that observation cannot resolve.

## Output

Use short, direct prose. State the result, evidence, and remaining uncertainty.
Do not claim to have queried an integration, read history, or run a command that
was unavailable.
