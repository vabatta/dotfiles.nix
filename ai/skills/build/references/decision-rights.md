# Decision rights

Who settles each decision, with the owner present and with the owner absent. This file is the single source. **architect** step 3, **review**'s stop rules, **figure-it-out** step 4, and the Delegations section of **unattended**'s contract point here and do not restate it.

Every row has an absent answer. Presence only upgrades some rows to "ask the owner". A row without an absent answer is a gap, so fill the gap before the run depends on it.

## Roles

| Role | Who | Can decide | Can never |
|---|---|---|---|
| Owner | the human | anything; sole authority to change the map or merge | – |
| Lead | the session running the skill | anything undoable inside the map, as a ruling | edit the map, merge or publish |
| Builder | the lead or a subagent | implementation within the sketch | loosen a check, change the sketch on its own |
| Reviewer | a fresh-context subagent | nothing; files findings with evidence | edit; re-file a rejected finding without new evidence |
| Final reviewer | another model | same as reviewer | same as reviewer |
| Arena judge | a subagent | scores and selects against the rubric | ship; the lead adopts or rejects the selection |
| Gates | lint, CI, and the host's merge rules | pass or fail | be overridden by any agent |

The map is the project's boundary config: its slices, the layers inside each, and every allowed cross-slice edge.

## Decisions

| # | Decision | Owner present | Owner absent |
|---|---|---|---|
| 1 | The map: slices, layers, a cross-slice edge, a shared kernel | The owner decides in **architect**'s Discuss mode, in grill rounds: recommendation, strongest alternative, cost of each | The lead does not decide. It stops that unit, proposes the edge in the report, and finishes the other units. When the run contract delegates this row, the lead decides through **arena** and a ruling, on a branch, and the merge stays with the owner under row 8 |
| 2 | Add or drop a port | The owner, inside **architect**. Elsewhere the lead rules under the two-adapter rule | The lead, through **arena** when more than one shape survives, plus a ruling |
| 3 | What a module owns, and its interface | The lead rules, the reviewer checks | Same |
| 4 | The boundary check fails | The builder fixes the code. A real need for a new edge becomes row 1 | Same, and row 1 uses its absent answer |
| 5 | Validity of a review finding | The lead marks it valid, rejected, or deferred, with a reason | Same |
| 6 | Stalled finding | The lead escalates to a stronger model, then rules with both arguments. The owner gets one question only when the finding touches row 1 or row 8 | The ruling goes in the report, the result is marked `not converged`, and that unit stops |
| 7 | New dependency or stack choice | The lead follows **build**'s stack ladder. A stack named in `AGENTS.md` is binding | Same, and a dependency with no precedent in the repo goes in the report |
| 8 | Merge, publish, push to main | The owner only | Never. Work lands on a branch or a draft PR |
| 9 | Comments, notes, rationale | The lead | Same |

## How each answer is given

- **Owner present** means: ask once, with a recommendation, so a one-word answer works. No answer within the turn counts as absent, so one open question never stalls the run.
- **Lead decides** means: write a ruling with the choice, why, and the cost if wrong. List every ruling in the final report, so the owner can reverse any of them later.

```text
Ruling #2: provider is a port, with ABRouter as a composite adapter.
Why: 3 adapters; arena scored it 8.5 vs 6, the flag lost on leakage.
Cost if wrong: about 40 lines on feat/adyen-ab; delete ABRouter and the Protocol.
```
