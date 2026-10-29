#!/usr/bin/env bash
# Inventory .agent/: size per area and the files past an age, from git history.
# Usage: inventory.sh [days=30]
set -euo pipefail

days="${1:-30}"
cd "$(git rev-parse --show-toplevel)"
[ -d .agent ] || { echo "no .agent/ here"; exit 0; }
git rev-parse -q --verify HEAD > /dev/null || { echo "WARNING: no commits yet, commit .agent/ first"; exit 0; }

git check-ignore -q --no-index .agent && echo "WARNING: .agent/ is gitignored, un-ignore it so git can recover deletions"
[ -f .agent/.gitattributes ] || echo "WARNING: .agent/.gitattributes is missing, parallel branches will conflict on shared files"
[ -z "$(git status --porcelain .agent)" ] || echo "WARNING: uncommitted changes in .agent/, commit them before deleting anything"

now="$(date +%s)"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
git ls-files -z .agent | while IFS= read -r -d '' f; do
	t="$(git log -1 --format=%ct -- "$f")"
	lines=0
	[ -f "$f" ] && lines="$(wc -l < "$f" | tr -d ' ')"
	printf '%s\t%s\t%s\n' "$(( (now - ${t:-$now}) / 86400 ))" "$lines" "$f"
done > "$tmp"

echo "== by area (files, lines)"
awk -F'\t' '{split($3, p, "/"); n[p[2]]++; l[p[2]] += $2; tf++; tl += $2}
	END {for (a in n) printf "%s\t%d files\t%d lines\n", a, n[a], l[a]; printf "TOTAL\t%d files\t%d lines\n", tf, tl}' "$tmp" | sort
echo "== tracked files not touched for $days days or more: age_days, lines, path (oldest first, max 60)"
awk -F'\t' -v d="$days" '$1 >= d' "$tmp" | sort -rn | head -60
