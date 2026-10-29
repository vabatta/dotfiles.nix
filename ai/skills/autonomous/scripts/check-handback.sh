#!/usr/bin/env bash
# Check that an autonomous run left its whole record. Run from the workspace.
# Usage: check-handback.sh <slug>. Exits 1 and names each gap.
set -uo pipefail

slug="${1:?usage: check-handback.sh <slug>}"
cd "$(git rev-parse --show-toplevel)"
bad=0
gap() { printf '%s\n' "$1"; bad=1; }
need() { [ -s "$1" ] || gap "MISSING $2: $1"; }

c=".agent/runs/autonomous/$slug/contract.md"
need "$c" contract
if [ -s "$c" ]; then
	for field in "goal" "done predicate" "scope" "cap" "workspace" "authorized" "start commit"; do
		grep -qiE "^[[:space:]]*[-*#>]*[[:space:]]*\**$field" "$c" || gap "CONTRACT lacks the field: $field"
	done
	start="$(grep -i 'start commit' "$c" | grep -oE '[0-9a-f]{7,40}' | head -n 1)"
fi

l=".agent/decisions/$slug.tsv"
need "$l" ledger
if [ -s "$l" ]; then
	head -n 1 "$l" | grep -q '^ts' || gap "LEDGER has no ts header, write it with show-me-your-work log.sh: $l"
	[ "$(wc -l < "$l")" -ge 2 ] || gap "LEDGER has no rows: $l"
fi

need ".agent/handoffs/$slug.md" handoff
if [ -n "${start:-}" ] && git diff --quiet "$start" -- . ':(exclude).agent' 2>/dev/null; then
	echo "no change landed since $start, so no report is required"
else
	need ".agent/runs/report/$slug.html" report
fi
v=".agent/runs/autonomous/$slug/verdict.md"
need "$v" verdict
if [ -s "$v" ]; then grep -qiE '^[#* -]*verdict.*(accept|reject)' "$v" || gap "VERDICT has no verdict line naming accept or reject: $v"; fi
[ -z "$(git status --porcelain .agent)" ] || gap "UNCOMMITTED changes under .agent/, commit them"

[ "$bad" -eq 0 ] && echo "hand-back record complete"
exit "$bad"
