# Lenses

Pick three to five. Always include **dissent**. Add a lens of your own when the question needs a view the roster lacks, and give it a one-line mandate in the same form.

| Lens | Mandate |
|---|---|
| dissent | Argue for the strongest option the others are likely to reject, or against the favourite. Find the fact that kills it. |
| operator | The person who runs and debugs this at 3 a.m. What breaks, how you find out, how you recover. |
| maintainer | The cost a year from now: code to keep, concepts to learn, coupling added. |
| user | The person or agent who consumes the result. What they gain, what they now have to do. |
| security | Trust boundaries, secrets, blast radius of a mistake, what becomes reachable. |
| cost | Money, compute, tokens, and time per run, at today's and at ten times today's scale. |
| simplicity | The smallest change that gets most of the benefit. What can be deleted instead of added. |

## Brief

Send each lens this brief, filled in. Send the same facts to every lens.

```text
You are the <lens> lens. Mandate: <mandate>.

Question: <the proposal or open question, one sentence>
Options:
  A. <claim>
  B. <claim>
Kill criterion: <what makes an option not worth doing>
Grounding: <how the current system works and why, 3 to 6 lines>
Proven facts: <fact, with how it was proven>
Unproven facts: <fact>

For each option, answer from your mandate only:
- position: for | against | conditional (name the condition)
- reason: the one fact or consequence that decides it for you
- risk: the worst outcome you see
Then name the option you would choose and your confidence (high, medium, low).
Do not edit files. Under 200 words.
```

For a first round on an open question with no options, replace the options and the per-option block with: "Propose the one option you would choose, as a claim 'Doing X improves A without costing B', with your reason."
