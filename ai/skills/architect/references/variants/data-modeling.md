# Data modeling

**Pick when:** the work adds state, records, a schema, or a wire or file format, or changes who owns or writes data.

## Decisions to settle

1. The entities and how each is identified. Natural key, generated id, or content hash, and who mints it.
2. The invariants, and where each one is enforced. Hard-to-misuse types first, runtime checks at the boundary second, prose last.
3. The lifecycle: the states each entity moves through, as a state machine with its legal transitions.
4. The single source of truth for each fact. Everything else is derived, never synced.
5. Writers: who writes each piece of state. If two actors can write it, give each its own state and merge at the read boundary.
6. Persistence and format: where it lives, how it is versioned, and how an old record is read by new code.
7. Migration: how today's data reaches the new shape, and whether that step is a one-way door.

## Lenses

- Get the data shape right first. Trace each dominant access pattern through it. "We'll add an index or cache later" means the shape is wrong.
- Model the domain with types, not branch ladders. A sum type beats a struct with optional fields that are always set together.
- Make each transition idempotent. Ask what happens when it runs twice or crashes halfway.
- Validate at the boundary and trust the types inside.
- Name every type and field with the terms in the project glossary, when one exists. A business term that is fuzzy, overloaded, or not in the glossary is settled before it goes into a type, since a type fixes the word in every caller.
