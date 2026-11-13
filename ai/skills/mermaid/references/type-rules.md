# Rules per diagram type

Read the section for the type being drawn. These add to the rules in SKILL.md.

## Sequence Diagram Discipline

Sequence diagrams have their own grammar. Follow it precisely:

- **Declare participants** in the order they appear left-to-right. Use `participant` or `actor` with aliases for long names.
- **Solid arrows** (`->>`) for synchronous calls; **dashed arrows** (`-->>`) for responses.
- **Activation bars** (`activate`/`deactivate` or `+`/`-` shorthand) to show when a participant is processing.
- **`alt`/`else`/`opt`/`loop`/`par`/`critical`/`break`** blocks for control flow — use them, don't try to simulate branching with notes.
- **Notes** (`Note right of`, `Note over`) for context that doesn't fit in a message label.

Keep message labels as verbs or short verb phrases: "Place Order", "Return Token", "Validate Credentials" — not "The user submits an order request to the API gateway which then forwards it".

## State Diagram Discipline

State diagrams model lifecycles. Follow these conventions:

- Use `[*]` for start and end pseudo-states.
- Name states with noun phrases describing the condition: `Pending`, `Processing`, `Shipped` — not actions like `Process` or `Ship`.
- Transition labels are events or conditions that trigger the change: `payment received`, `timeout after 30m`, `cancel requested`.
- Use `state "Long Name" as shortId` for verbose state names.
- Use composite states (nested `state`) for states with sub-lifecycles, but limit nesting to one level.

## ER Diagram Discipline

Entity-relationship diagrams document data models. Follow these conventions:

- **Relationship labels are mandatory** — the colon-separated label is required by syntax and must be a short verb phrase: `"places"`, `"contains"`, `"belongs to"`.
- **Read relationships left-to-right** naturally: `CUSTOMER ||--o{ ORDER : "places"` → a customer places orders.
- **Use `--` (identifying) vs `..` (non-identifying) correctly**: `--` when the child has no meaning without the parent; `..` when both exist independently.
- **Cardinality notation**: `||` exactly one, `o|` zero or one, `}o` zero or more, `}|` one or more.
- **Attribute types and keys**: mark `PK`, `FK`, and data types for each attribute.

## Gantt Chart Discipline

Gantt charts map work to time. Follow these conventions:
- **`dateFormat`** is mandatory — always specify it (e.g., `dateFormat YYYY-MM-DD`).
- **Sections** group related tasks — use them to separate workstreams or phases.
- **Task states**: `done`, `active`, `crit` (critical path) — use `crit` sparingly for genuinely critical tasks.
- **Dependencies**: `after taskId` to show ordering — prefer this over absolute dates when the schedule is relative.
- Keep the total timeline readable — if it spans more than ~20 tasks, split into multiple charts per phase.
