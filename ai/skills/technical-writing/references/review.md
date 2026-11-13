# Review checklist and worked example

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.

The fixes, by layer: "configuration is performed" becomes "`budget.mjs` reads", so someone does something (**unslop**). "Ratchet" goes away. The script's real filename does the naming (**unslop**). The five-noun string breaks up into plain clauses (Global English). The hedge "note that it's important to remember" is deleted (**unslop**). The failure condition moves ahead of the step it explains (STE). The buried "should only be done when lowering" becomes a command with "only" next to its verb (STE). "If exceeded" gets a subject: the count (Global English).

## Review checklist

Apply to any prose this skill covers. Done when every item passes. Item 1 applies to document sets and READMEs:

1. Is each file, or each README section, one Diátaxis mode, with links where modes meet?
2. Is every instruction written as a command, with its condition in front?
3. Does any sentence carry two instructions or two thoughts? Split it.
4. Does **unslop** find anything to cut or replace?
5. Is "only" next to the word it changes? Does every "it" point at one thing? Does every clause keep its verb?
6. Does each thing have exactly one name across the docs?
7. Does every name match the real symbol, file, flag, or command?
8. Are all symbols, paths, and counts real at this commit, with the commands that regenerate the counts?
