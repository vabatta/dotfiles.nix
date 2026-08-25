#!/usr/bin/env python3
"""Validate the shared AI model policy."""

from __future__ import annotations

import json
import argparse
import os
from pathlib import Path


ROLE_NAMES = {"exploration", "implementation", "judgment", "prose"}
TOP_LEVEL_NAMES = {"default", "roles"}


def config_dir() -> Path:
    value = os.environ.get("XDG_CONFIG_HOME")
    return Path(value) if value else Path.home() / ".config"


def load_policy(path: Path) -> dict[str, object]:
    try:
        value = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise SystemExit(f"invalid policy {path}: {error}") from error

    if not isinstance(value, dict):
        raise SystemExit("policy must be a JSON object")
    if set(value) != TOP_LEVEL_NAMES:
        raise SystemExit(f"policy keys must be {sorted(TOP_LEVEL_NAMES)}")
    if not isinstance(value["default"], str) or not value["default"].strip():
        raise SystemExit("default must be a non-empty string")

    roles = value["roles"]
    if not isinstance(roles, dict) or set(roles) != ROLE_NAMES:
        raise SystemExit(f"role keys must be {sorted(ROLE_NAMES)}")
    if any(not isinstance(model, str) or not model.strip() for model in roles.values()):
        raise SystemExit("every role model must be a non-empty string")

    return value


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "policy",
        nargs="?",
        type=Path,
        default=config_dir() / "ai/model-policy.json",
    )
    args = parser.parse_args()
    load_policy(args.policy)
    print("valid AI model policy")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
