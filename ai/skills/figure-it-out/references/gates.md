# Gates for a code unit

Every unit that changes code passes these gates in order. Run a gate when its condition holds. Otherwise skip it and write the reason in one line. Build always runs, and ends with **review**.

| Gate | Skill | Run when | Skip when |
|---|---|---|---|
| Understand | how, plus why when the current shape is questioned | The unit touches code not traced in this session | The path is already traced |
| Examine | investigate | The goal is a quality (faster, more reliable, cleaner) with no candidate change | A candidate change exists |
| Decide | assess | There is more than one way to go, or the change is costly or one-way | One obvious change behind a two-way door |
| De-risk | prototype | The approach is unproven here: a new library, unknown feasibility, an unclear UI | The codebase already does it this way |
| Design | architect | The unit adds a module, an interface, a data shape, or infrastructure | The change stays inside existing shapes |
| Compare | arena | Two or more designs survive Decide, or the implementation is open, and building candidates is cheaper than arguing | One design and one implementation clearly win |
| Build | build, which runs review | Always | Never |

A gate's output feeds the next gate: the findings become the options to assess, the verdict and prototype answer constrain the design, and the chosen design is what build implements. A gate that changes the picture, such as a verdict of don't, sends the unit back to Frame.
