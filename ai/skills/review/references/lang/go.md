# Go

**Pick when:** the diff touches `.go` files or `go.mod`.

Hunt for what reviewers of Go code most often miss:

- An error that is discarded, shadowed by `:=` in an inner scope, or wrapped without `%w`, so `errors.Is` and `errors.As` stop matching.
- A slice appended to after being shared, so two owners write into one backing array. A sub-slice kept alive that pins a large array.
- A goroutine with no way to stop: no `context.Context`, no closed channel, or a send on a channel nobody reads.
- A loop variable or a map captured across goroutines without a lock. A `sync` value copied by value.
- `defer` inside a loop, which holds resources until the function returns.
- Integer conversion that silently truncates or overflows, such as `int64` to `int32` or a length cast.
- A nil interface that is not nil because it holds a typed nil pointer.
- An HTTP response body or file never closed on an error path.
- A test that never fails: no assertion, `t.Parallel` sharing state, or a table case that ignores its expected value.
