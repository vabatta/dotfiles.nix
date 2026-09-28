#!/usr/bin/env bash
# Validate a skill bundle: frontmatter, relative links, stray metadata,
# and cross-references to other skills.
set -u

skills_dir="${1:-ai/skills}"

if [ ! -d "$skills_dir" ]; then
  printf 'error: skills directory not found: %s\n' "$skills_dir" >&2
  exit 2
fi

failures=0
warnings=0
checked=0

fail() {
  failures=$((failures + 1))
  printf 'FAIL: %s\n' "$1"
}

warn() {
  warnings=$((warnings + 1))
  printf 'WARN: %s\n' "$1"
}

tmp_dir="$(mktemp -d)"
known_file="$tmp_dir/known"
tokens_file="$tmp_dir/tokens"
: > "$tokens_file"
trap 'rm -rf "$tmp_dir"' EXIT

for dir in "$skills_dir"/*/; do
  [ -d "$dir" ] || continue
  basename "$dir"
done > "$known_file"

for skill_md in "$skills_dir"/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  checked=$((checked + 1))
  dir_name="$(basename "$(dirname "$skill_md")")"

  if [ "$(head -n 1 "$skill_md")" != "---" ]; then
    fail "$skill_md: missing frontmatter"
    continue
  fi

  frontmatter="$(awk 'NR == 1 { next } $0 == "---" { exit } { print }' "$skill_md")"

  name="$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -n 1 \
    | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//" | tr -d '\r')"

  if [ -z "$name" ]; then
    fail "$skill_md: frontmatter missing name"
  elif [ "$name" != "$dir_name" ]; then
    fail "$skill_md: name '$name' does not match directory '$dir_name'"
  fi

  if ! printf '%s\n' "$frontmatter" | grep -q '^description:'; then
    fail "$skill_md: frontmatter missing description"
  else
    desc_line="$(printf '%s\n' "$frontmatter" | grep -m1 '^description:')"
    desc_val="${desc_line#description:}"
    desc_val="${desc_val# }"
    case "$desc_val" in
      '>' | '|' | '>-' | '|-' | '')
        fail "$skill_md: description must be single-line prose"
        ;;
      *)
        if printf '%s' "$desc_val" | grep -qE '[:;]'; then
          fail "$skill_md: description contains a colon or semicolon"
        fi
        if printf '%s' "$desc_val" | grep -q ' #'; then
          fail "$skill_md: description contains ' #' which YAML reads as a comment"
        fi
        ;;
    esac
    desc_n="$(printf '%s\n' "$frontmatter" | grep -n -m1 '^description:' | cut -d: -f1)"
    next_line="$(printf '%s\n' "$frontmatter" | sed -n "$((desc_n + 1))p")"
    case "$next_line" in
      ' '* | $'\t'*)
        fail "$skill_md: description has an indented continuation line"
        ;;
    esac
  fi

  if grep -qF '](../' "$skill_md"; then
    fail "$skill_md: relative link '](../'"
  fi

  grep -oE '`[a-z][a-z0-9-]*`' "$skill_md" | sed -e 's/^`//' -e 's/`$//' >> "$tokens_file"
  grep -oE '\*\*[a-z][a-z0-9-]*\*\*' "$skill_md" | sed -e 's/^\*\*//' -e 's/\*\*$//' >> "$tokens_file"
done

if [ -e "$skills_dir/.DS_Store" ]; then
  fail "$skills_dir/.DS_Store: unexpected macOS metadata file"
fi

sort -u -o "$tokens_file" "$tokens_file"
while IFS= read -r token; do
  [ -n "$token" ] || continue
  if [ "${token#principle-}" != "$token" ] || grep -qxF "$token" "$known_file"; then
    if [ ! -d "$skills_dir/$token" ]; then
      warn "unresolved skill reference: $token"
    fi
  fi
done < "$tokens_file"

printf '\n'
printf 'skills checked: %s\n' "$checked"
printf 'failures: %s\n' "$failures"
printf 'warnings: %s\n' "$warnings"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
exit 0
