#!/usr/bin/env bash
# batpipe: preprocessor for less via LESSOPEN
# usage: LESSOPEN="| /path/to/batpipe.sh %s"

file="$1"

# exit early if no file
[[ -z "$file" ]] && exit 1

# directory: list contents
if [[ -d "$file" ]]; then
  if command -v eza &>/dev/null; then
    eza -la --color=always --icons "$file"
  else
    ls -la --color=always "$file"
  fi
  exit 0
fi

# non-existent file
[[ ! -e "$file" ]] && exit 1

# handle by extension
case "${file,,}" in
  # archives
  *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz)
    tar -tvf "$file" 2>/dev/null ;;
  *.zip|*.jar|*.war|*.ear)
    unzip -l "$file" 2>/dev/null ;;
  *.rar)
    unrar l "$file" 2>/dev/null ;;
  *.7z)
    7z l "$file" 2>/dev/null ;;
  *.gz)
    gzip -l "$file" 2>/dev/null ;;

  # documents
  *.pdf)
    pdftotext -layout "$file" - 2>/dev/null ;;
  *.docx|*.odt)
    pandoc -t plain "$file" 2>/dev/null ;;

  # images (show metadata)
  *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp|*.ico|*.svg)
    if command -v exiftool &>/dev/null; then
      exiftool "$file" 2>/dev/null
    elif command -v file &>/dev/null; then
      file "$file"
    fi ;;

  # binary/data files
  *.bin|*.exe|*.dll|*.so|*.dylib)
    file "$file"
    hexdump -C "$file" 2>/dev/null | head -100 ;;

  # sqlite
  *.db|*.sqlite|*.sqlite3)
    sqlite3 "$file" ".tables" 2>/dev/null ;;

  # default: use bat for syntax highlighting
  *)
    bat --color=always --paging=never --style=numbers "$file" 2>/dev/null
    ;;
esac
