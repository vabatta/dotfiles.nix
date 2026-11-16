# Writing skills in this folder

Rules for authoring and editing the `SKILL.md` files here. **skill-creator** owns the
method and **writing-for-agents** the wording.

## Frontmatter

Required fields are `name` and `description`. Add no key other than the optional
`license`, `compatibility`, and `metadata`.

- `name` is 1 to 64 characters, lowercase letters, digits, and single hyphens, matching
  the directory name. No leading or trailing hyphen and no double hyphen.
- `description` is 1 to 1024 characters, a single unbroken line of prose.

## Descriptions

The description is the only always-loaded content. It is how the agent chooses a skill
from dozens, so it carries the whole routing decision. Write it as one line with two
parts.

1. What the skill does, in the third person. Start with a verb. "Runs an acceptance pass
   on a diff." Never first or second person, so no "I can help you" and no "You can use
   this to".
2. When to use it, with the concrete triggers a user would say. "Use when asked to
   review, check, or accept a change."

Then the local rules:

- No colon and no semicolon anywhere in the description. The line is injected into a
  tool description, where both confuse parsing.
- No ` #`, which YAML reads as a comment.
- Never name another skill in the description. Each description stands alone. If two
  triggers collide, sharpen this skill's own trigger or fix the boundary between the
  skills, do not route in prose.
- Stay under the 1024 limit, but do not pad. A vague description is worse than a short
  precise one.

## Body

- Keep `SKILL.md` under 500 lines. Push detail into `references/` and point at it.
- Bundle what is fixed. `SKILL.md` holds the judgment. A fixed output shape is a template
  in `assets/`, a fixed brief for a subagent or a lookup table is in `references/`, and a
  fixed command sequence is an executable script in `scripts/`. Do not describe any of
  them in prose. Point at the file and say when to use it.
- Variants. When a skill's method differs by case, give each case a variant: its own file
  under `references/` when it runs past a screen, or a `##` section of one shared file when
  short. Each variant opens with a `**Pick when:**` line. `SKILL.md` lists the variants in a
  `| Variant | Pick when |` table whose first column links each one (a section by its
  anchor), and says to read only the chosen variant. Routing between skills lives in
  **figure-it-out**, never in variants.
- Keep references one level deep from `SKILL.md`; never reference a file that only
  another reference reaches.
- Name files by content, use forward slashes, and give each reference a one-line pointer
  from `SKILL.md` saying what it is and when to read it.
- Use third-person instructions in the imperative for the agent. Every step ends on a
  completion criterion. A short sequential procedure can end on one instead, so done and not-done are checkable.
- Route to other skills by their full name in bold, for example **build**. Do not
  restate another skill's contract; point at it.
- Skills run in any agent harness, on macOS or Linux. Name the action, such as "dispatch a
  subagent", "search the web", or "track the task list", never a harness's tool name. gm, Nix,
  `git`, `grep`, `gh`, `jq`, `python3`, and `validate-mermaid` are always present. For
  anything else a step needs, say what to do when it is absent.
- Commands and scripts run on both macOS and Linux: bash 3.2, and only the flags BSD and
  GNU tools share. Branch on the OS only where the tools differ, as `open` and `xdg-open` do.
- A skill that fans out runs its workers as subagents where the harness has them, and says
  what to do inline when it has none. A step that would ask the human names a default to use
  when no one answers (see **build**, "Deciding without asking").
- A skill that another skill can call ends its procedure by returning to the caller's next
  step. A sub-skill's last line that reads like the end of the job stops the whole run.
- Nothing commits, pushes, opens a pull request, or publishes unless the user's task says so.
- Wording doctrine is owned by **writing-for-agents**.

## Artifact layout

Skills keep almost nothing in files. The code is the source of truth. What code cannot
say goes to a gm note through **memory**, with a `--topic` of `<skill>/<slug>`.

- Durable project knowledge a reviewer needs, under `docs/`: `docs/glossary.md`,
  and `docs/glossary-map.md` with `docs/glossary/<context>.md` when a repo has multiple
  contexts. Nothing else is promoted into `docs/`.
- Everything else a skill writes goes under `.agents/<folder>/`: `prototypes/<slug>/`,
  `evals/<skill-name>/`, `runs/<slug>.md`, `reports/<slug>.html`, `teaching/`, and
  `wizards/<slug>.sh`. Nothing there may hold a secret, token, or personal data.
- Work tracking lives in the issue tracker.

One task uses one slug in every artifact it writes. Unrelated work starts a new slug.

A skill's own `references/`, `scripts/`, and `assets/` ship with the skill. They are
not project artifacts and never go under `docs/`.

A skill names only the artifacts it owns. To point at another skill's files, name
that skill; never repeat its paths. The owner skill is the single source for its
own layout.
