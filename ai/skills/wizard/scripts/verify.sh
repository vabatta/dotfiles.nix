#!/usr/bin/env bash
# Static checks for an authored wizard: syntax and executable bit.
# Usage: verify.sh .agents/wizards/<slug>.sh
set -euo pipefail
wizard="${1:?usage: verify.sh <wizard.sh>}"
bash -n "$wizard"
chmod +x "$wizard"
echo "ok: $wizard passes bash -n and is executable"
