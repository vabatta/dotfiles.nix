# Go

**Pick when:** the repo has a `go.mod`, or the change touches `.go` files.

- Find the commands before guessing them: a `Makefile`, `justfile`, `Taskfile.yml`, or CI file first, then `go test ./...` and `go vet ./...`. Run with `-race` when the change touches goroutines.
- Prefer the standard library that newer Go added over a dependency or a hand-rolled helper: `slices`, `maps`, `cmp`, `min` and `max`, `log/slog`, `errors.Join`, `context.AfterFunc`, `sync.OnceValue`, range over an integer or a function, and the method and wildcard patterns in `net/http.ServeMux`.
- Avoid, then use instead:

  | Avoid | Use instead |
  |---|---|
  | `interface{}` | `any` |
  | `ioutil.*` | the `io` and `os` equivalents |
  | `sort.Slice` on a slice of ordered values | `slices.Sort` or `slices.SortFunc` |
  | an `errors` package dependency for wrapping | `fmt.Errorf("...: %w", err)` |
  | a logger dependency in a new package | `log/slog`, unless the project already uses another |

- Return errors and wrap them with context at each boundary. Panic only on a programmer error.
- Pass `context.Context` as the first parameter to anything that blocks or does I/O.
- Write table-driven tests with `t.Run` names that state the behavior.
