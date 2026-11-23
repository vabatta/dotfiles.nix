#!/usr/bin/env bash
# Usage: stale-refs.sh [path...]
# Lists the symbols and files that live gm notes and code comments name but the
# repository no longer has. Comments are whole comment lines. With paths, only
# comments under those paths are read.
# Notes are always read in full, since a deleted symbol makes an unchanged note stale.
# Exit 0 when nothing is stale, 1 when something is, 2 on error.
#
# A name counts as present when a path with that name exists, or when it appears on
# a line that is not a comment, outside markdown and the notes. A mention in another
# comment or a doc does not keep a name alive.
# Note sections Rejected and What happened are history and may name what never existed
# or is gone, so they are skipped. Fact and Evidence describe things outside the
# repository, so only paths are checked there.
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "stale-refs: not in a git repository" >&2; exit 2; }
cd "$root"

notes=$(git config -f .gmconfig gm.dir 2>/dev/null || echo .agents/memory)
notes=${notes%/}
tmp=$(mktemp -d "${TMPDIR:-/tmp}/stale-refs.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

comment_re='^[[:space:]]*(#|//|/\*|\*|--|;)'

# Each input line is file<TAB>line<TAB>mode<TAB>text, mode "all" or "paths".
# Each output line is file<TAB>line<TAB>kind<TAB>name, kind "path" or "sym".
extract() {
  awk -F '\t' '
    function emit(name, kind) {
      sub(/:[0-9]+(-[0-9]+)?$/, "", name)
      sub(/\(\)$/, "", name)
      if (length(name) < 3) return
      if (name ~ /:\/\// || name ~ /^[\/~]/) return
      if (name ~ /^path\/to\//) return
      if (name ~ /\//) { print $1 "\t" $2 "\tpath\t" name; return }
      if (mode != "all") return
      if (name ~ /^[A-Za-z_][A-Za-z0-9_]*([.:#]+[A-Za-z_][A-Za-z0-9_]*)*$/) print $1 "\t" $2 "\tsym\t" name
    }
    {
      mode = $3; text = $4
      while (match(text, /`[^` ]+`/)) {
        emit(substr(text, RSTART + 1, RLENGTH - 2))
        text = substr(text, RSTART + RLENGTH)
      }
      text = $4
      gsub(/`[^`]*`/, " ", text)
      gsub(/[A-Za-z][A-Za-z0-9+.-]*:\/\/[^ ]*/, " ", text)
      while (match(text, /[A-Za-z0-9_.-]+\/[A-Za-z0-9_.\/-]*\.[A-Za-z0-9]+/)) {
        emit(substr(text, RSTART, RLENGTH))
        text = substr(text, RSTART + RLENGTH)
      }
    }'
}

[ $# -gt 0 ] || set -- .

# Live note bodies, minus the history sections and the header.
if [ -d "$notes" ]; then
  gm list --json > "$tmp/notes.json" || { echo "stale-refs: gm list failed" >&2; exit 2; }
  jq -r '.[].file' "$tmp/notes.json" | while IFS= read -r f; do
    [ -f "$f" ] || continue
    awk -v f="$f" '
      NR == 1 && /^---$/ { head = 1; next }
      head && /^---$/ { head = 0; next }
      head { next }
      /^## / {
        s = substr($0, 4)
        mode = (s == "Rejected" || s == "What happened") ? "skip" : (s == "Fact" || s == "Evidence") ? "paths" : "all"
        next
      }
      mode != "skip" && mode != "" { print f "\t" NR "\t" mode "\t" $0 }
    ' "$f"
  done | extract >> "$tmp/refs"
fi

# Comment lines in tracked files, minus markdown and the notes.
git grep -nIE "$comment_re" -- "$@" ":(exclude)*.md" ":(exclude)$notes" 2>/dev/null |
  awk '{ i = index($0, ":"); f = substr($0, 1, i - 1); r = substr($0, i + 1); j = index(r, ":"); print f "\t" substr(r, 1, j - 1) "\tall\t" substr(r, j + 1) }' |
  extract >> "$tmp/refs" || true

[ -s "$tmp/refs" ] || { echo "stale-refs: no references found"; exit 0; }

present() {
  kind=$1 name=$2 from=$3
  if [ "$kind" = path ]; then
    p=${name#./}
    [ -e "$p" ] || [ -e "$(dirname "$from")/$p" ] && return 0
    git ls-files | grep -qF -e "/$p" -e "$p/" && return 0
    return 1
  fi
  git ls-files | grep -qE "(^|/)$(printf '%s' "$name" | sed 's/[.]/[.]/g')\$" && return 0
  last=$(printf '%s' "$name" | sed 's/.*[.:#]//')
  case $last in
    py|go|ts|tsx|js|mjs|rs|nix|sh|md|json|yaml|yml|toml|lock|txt|cfg|ini) return 1 ;;
  esac
  git grep -nIwF -e "$last" -- . ":(exclude)*.md" ":(exclude)$notes" 2>/dev/null |
    awk '{ i = index($0, ":"); r = substr($0, i + 1); j = index(r, ":"); print substr(r, j + 1) }' |
    grep -qvE "$comment_re"
}

sort -u "$tmp/refs" | while IFS="$(printf '\t')" read -r file line kind name; do
  present "$kind" "$name" "$file" || printf '%s:%s: %s not found\n' "$file" "$line" "$name"
done > "$tmp/stale"

if [ -s "$tmp/stale" ]; then
  cat "$tmp/stale"
  echo "stale-refs: $(wc -l < "$tmp/stale" | tr -d ' ') stale reference(s)"
  exit 1
fi
echo "stale-refs: $(sort -u "$tmp/refs" | wc -l | tr -d ' ') reference(s) checked, none stale"
