---
tags: [writing]
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

write the PR description for my change. I replaced the custom retry loop in `internal/fetch/client.go` with hashicorp/go-retryablehttp, because the old loop retried POST requests and double-charged two customers last week (issue #412). I added a test that a POST is never retried. `go test ./internal/fetch/...` passes. The diff is +38/-112.
