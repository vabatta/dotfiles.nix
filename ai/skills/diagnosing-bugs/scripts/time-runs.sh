#!/usr/bin/env bash
# Time a command N times with the bash `time -p` keyword and print min, median, and max wall seconds.
# Usage: time-runs.sh <runs> <command> [args...]   Exits 1 if any run failed.
set -uo pipefail
[ $# -ge 2 ] || { echo "usage: time-runs.sh <runs> <command> [args...]" >&2; exit 2; }
runs="$1"; shift
out="$(mktemp)"; times="$(mktemp)"; trap 'rm -f "$out" "$times"' EXIT
i=0 status=0
while [ "$i" -lt "$runs" ]; do
  i=$((i + 1))
  { time -p "$@" >/dev/null 2>&1; } 2>"$out" || status=1
  awk '$1 == "real" { print $2 }' "$out" >> "$times"
done
sort -n "$times" | awk '{ v[NR] = $1 } END { printf "runs %d  min %s  median %s  max %s\n", NR, v[1], v[int((NR + 1) / 2)], v[NR] }'
exit "$status"
