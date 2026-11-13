#!/usr/bin/env bash
# Find nixpkgs packages matching a query.
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: find-package.sh <query>" >&2; exit 2; }
nix search nixpkgs "$1" --json | head -c 6000
echo
