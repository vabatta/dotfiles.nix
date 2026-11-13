#!/usr/bin/env bash
# Stage flake files, lock, and prove the dev shell provides <binary>. Run from the flake directory.
# Flakes read only git-tracked files, so each new file is staged before the next command.
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: check-flake.sh <binary>" >&2; exit 2; }
in_git() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }
in_git && git add flake.nix
nix flake lock
in_git && git add flake.lock
nix develop --command sh -c "command -v $1"
