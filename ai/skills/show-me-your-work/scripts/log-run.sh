#!/usr/bin/env bash
# Run a check and log its real outcome as a show-me-your-work row. Failures are logged too.
# Usage: log-run.sh <logfile> <phase> <decision> <why> -- <command> [args...]
# Exits with the command's code, or 70 when the row could not be written.
set -uo pipefail

if [ "$#" -lt 6 ] || [ "$5" != "--" ]; then
	printf 'usage: log-run.sh <logfile> <phase> <decision> <why> -- <command> [args...]\n' >&2
	exit 1
fi

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
logfile="$1" phase="$2" decision="$3" why="$4"
shift 5

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
"$@" 2>&1 | tee "$tmp"
rc="${PIPESTATUS[0]}"
last="$(LC_ALL=C grep -av '^[[:space:]]*$' "$tmp" | tail -n 1 | LC_ALL=C cut -c1-120)"
if [ "$rc" -eq 0 ]; then verdict="passed"; else verdict="FAILED"; fi

"$here/log.sh" "$logfile" "$phase" "$decision" "$why" "$(printf '%q ' "$@")" "$verdict, exit $rc: $last" \
	|| { printf 'log-run: row not written to %s\n' "$logfile" >&2; exit 70; }
exit "$rc"
