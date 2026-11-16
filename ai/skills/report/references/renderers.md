# Renderers

## HTML

**Pick when:** a tool that shows an HTML page inline is present, or the user asked for a page.

1. Copy `assets/report.html` from this skill. Keep its `<style>` block as it is. Fill the blocks you mapped, delete the blocks you did not use, and delete the comments.
2. Draw each figure as inline SVG. Use the `<figure>` sample in the template as the pattern. Start lines past the longest label, and color strokes with the chip variables. Do not load a script, a font, or a stylesheet from the network, because inline preview frames often run inline scripts but block remote ones.
3. Keep colors on the variables in `:root`. They map to the host theme when it has one and fall back to fixed values in a plain browser.
4. Preview the page first if the host has a preview tool, at the default width and again at 390 pixels. Fix overflow and overlapping labels, then render it with the reported content height.
5. If the host cannot show the page inline, write it to `.agents/reports/<slug>.html` at the repository root and give its absolute path.

Done when the page displays with no console error and no horizontal overflow at 390 pixels, or its path is given.

## Markdown

**Pick when:** no tool that shows HTML inline is present and no page was asked for.

1. Copy `assets/report.md` from this skill. Fill it in the same block order as the HTML.
2. Write each chip as its glyph followed by the word, for example `● sourced` or `■ off`.
3. Write rows as list items, not tables. Use a table only when it has three columns or fewer and every cell is shorter than 30 characters.
4. Give a figure as a Mermaid block checked with `validate-mermaid`, or leave it out when the rows already show the relations.

Done when the markdown has no table wider than three columns and every status is a glyph and a word.
