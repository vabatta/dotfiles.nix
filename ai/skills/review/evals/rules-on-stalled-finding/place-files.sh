#!/usr/bin/env bash
set -eu
here=$(dirname "$0")
cp -R "$here/files/." .
git init -q
git add -A
git -c user.name=eval -c user.email=eval@example.invalid commit -qm base
mkdir -p .agents
cp -R "$here/change/." .
