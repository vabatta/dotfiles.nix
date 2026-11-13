#!/usr/bin/env bash
# Lists leftover debug logs tagged [DEBUG-xxxx] in tracked and untracked files. Exits 1 when any remain.
# Usage: debug-tags.sh [tag]   with a tag such as a4f2, lists only that tag.
set -euo pipefail
pattern="\[DEBUG-${1:-[A-Za-z0-9]+}\]"
if git grep -nIE --untracked "$pattern"; then
  exit 1
fi
echo "no debug tags left"
