#!/usr/bin/env bash
# Run a command N times and report the failure rate. Exits 1 if any run failed.
# Usage: repeat.sh <runs> <command> [args...]   (stop at the first failure with STOP=1)
set -uo pipefail
[ $# -ge 2 ] || { echo "usage: repeat.sh <runs> <command> [args...]" >&2; exit 2; }
runs="$1"; shift
fails=0 i=0
while [ "$i" -lt "$runs" ]; do
  i=$((i + 1))
  if ! "$@" >/dev/null 2>&1; then
    fails=$((fails + 1)); echo "run $i: FAIL"
    [ "${STOP:-0}" = 1 ] && break
  fi
done
echo "failed $fails of $i runs"
[ "$fails" -eq 0 ]
