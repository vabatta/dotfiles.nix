#!/usr/bin/env bash
# Net added source lines since a base, excluding tests, generated files, lockfiles, and binaries.
# Usage: net-lines.sh [base] [budget]. Base defaults to the merge-base with origin's default branch, else HEAD.
# Counts committed, uncommitted, and untracked changes. Exits 1 when net exceeds the budget.
set -euo pipefail
base="${1:-}" budget="${2:-}"
if [ -z "$base" ]; then
  default="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  base="$( [ -n "$default" ] && git merge-base HEAD "$default" 2>/dev/null || git rev-parse HEAD)"
fi
excluded() {
  case "$1" in
    *_test.* | *.test.* | *.spec.* | test/* | */test/* | tests/* | */tests/* | */__tests__/* | testdata/* | */testdata/*) return 0 ;;
    *.lock | *lock.json | *lock.yaml | go.sum | */go.sum | *.gen.* | *_generated.* | *.generated.* | *.pb.go | generated/* | */generated/*) return 0 ;;
  esac
  return 1
}
added=0 deleted=0 skipped=0
while IFS=$'\t' read -r a d path; do
  if [ "$a" = "-" ] || excluded "$path"; then skipped=$((skipped + 1)); else added=$((added + a)) deleted=$((deleted + d)); fi
done < <(git diff --numstat "$base" --)
while IFS= read -r path; do
  if excluded "$path" || ! grep -Iq . "$path" 2>/dev/null; then skipped=$((skipped + 1)); else added=$((added + $(wc -l < "$path"))); fi
done < <(git ls-files --others --exclude-standard)
net=$((added - deleted))
printf 'base %s\nadded %d\ndeleted %d\nnet %d\nexcluded files %d\n' "$(git rev-parse --short "$base")" "$added" "$deleted" "$net" "$skipped"
[ -z "$budget" ] && exit 0
printf 'budget %d: %s\n' "$budget" "$([ "$net" -le "$budget" ] && echo within || echo OVER)"
[ "$net" -le "$budget" ]
