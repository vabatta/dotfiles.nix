# Code design

**Pick when:** the candidates are shapes: types, signatures, module maps, and the caller's usage, with no working bodies.

- **Candidate:** a design package per **architect**'s rationale template, with the caller's usage first and the type sketch derived from it.
- **Location:** one folder per writer under `.agents/arena/<slug>/<N>/`. A checkout is needed only when a writer must compile its stubs against the real code.
- **Default rubric:** interface depth, fit of the data structures, agreement with the caller's usage, and count of design red flags.
- **Verify:** the synthesized usage examples type-check against the synthesized stubs, or read through by hand when there is no compiler.
- **Return:** the synthesized package only. The caller writes it into the codebase.
