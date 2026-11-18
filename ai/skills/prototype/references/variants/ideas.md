# Ideas prototype

**Pick when:** the question is "what should this be like?" for something you judge by looking at it or using it: a UI, a CLI flow, a config or file format, a PR or message template, a report layout.

The artifact is three, at most five, radically different variants of the concept, shown side by side or behind one switch. Structurally different, not colour or copy differences.

## Sub-shapes

Pick by what is being judged.

- **UI.** A route that renders the variants behind `?variant=`. Prefer adjusting an existing page: keep its data, params, and auth, and swap only the rendering. As a last resort, add a throwaway route named `prototype` following existing routing. Generate the variants against real data and the real component library, with clear `VariantA`, `VariantB`, `VariantC` exports. Wire one floating bottom-centre switcher bar: left and right arrows wrap, it shows the variant label, `←` and `→` keys work except inside inputs and contenteditable, and it is hidden in production.
- **CLI or flow.** A script per variant under `.agents/prototypes/<slug>/` that prints a realistic session: the commands typed and the output shown, for the common path and one awkward case.
- **Format or template.** One file per variant filled with real data from this project, such as a real config, a real PR, or a real report, plus one line on what each variant makes easy and what it makes hard.

## Rules and capture

No real mutations and no direct promotion to production. Hand over the URL or the files, and record the winning variant in the verdict. A UI variant set stays on a throwaway branch off main. Other sub-shapes stay in `.agents/prototypes/<slug>/` until the verdict is saved, then are deleted.
