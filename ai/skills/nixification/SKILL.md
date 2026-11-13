---
name: nixification
description: "Resolves a missing tool, binary, library, or dependency with Nix flakes or an ephemeral shell. Use on command not found, missing-package errors, or a request to create a flake.nix or reproducible environment. Not for NixOS system or home-manager configuration, nor for errors whose cause is not an absent tool."
---

# Nixification

Resolve missing tools and dependencies using Nix, favoring flakes for reproducibility.

## Core Principle

When a dependency is missing, don't just run an ad-hoc `nix shell` one-liner and move on. Prefer creating (or extending) a `flake.nix` so the environment is reproducible. Fall back to ephemeral `nix shell` only for one-off, throwaway commands. Tie-break: one tool used once means ephemeral. A tool reused, or two or more tools, means a flake.

## Decision Flow

1. **Check if a `flake.nix` already exists** in the project root (or the working directory).
   - If yes → read it, add the missing package to `buildInputs` (or create a `devShells` output from [assets/flake.nix](assets/flake.nix) when none exists), and run commands in it with `nix develop --command <cmd>`.
   - If no → apply step 2.

2. **Apply the tie-break above.** A request for a flake means a flake. A request for a quick or throwaway approach means ephemeral.

## Finding Packages

Before adding a package, check the current environment and project dependencies first. Before
assuming a package name, run [scripts/find-package.sh](scripts/find-package.sh) `<query>`. It runs `nix search nixpkgs`.

Package names in nixpkgs often differ from the binary name — e.g., the `rg` binary is `ripgrep`, `fd` is `fd`, `python3` may be `python3Full` or `python312`.

## Ephemeral Shell (one-off)

Run a single command without persisting anything:

```bash
nix shell nixpkgs#<package> --command <binary> [args...]
```

**Example:** `nix shell nixpkgs#yq-go --command yq '.version' chart.yaml`

To enter an interactive shell with multiple packages:

```bash
nix shell nixpkgs#yq-go nixpkgs#tree
```

## Creating a flake.nix

Copy [assets/flake.nix](assets/flake.nix), fill in the description, and add the packages to `buildInputs`. It needs only `nixpkgs`, so it adds no `flake-utils` input. Then run [scripts/check-flake.sh](scripts/check-flake.sh) `<binary>` from the flake directory. It stages `flake.nix` and `flake.lock` in a git repo (flakes read only tracked files), locks, and prints the binary's path from `nix develop`.

Done when the script prints the path of the missing binary.

## Extending an Existing flake.nix

Read the current file, locate the `buildInputs` list, and append the missing package. Do not rewrite unrelated parts of the flake. After editing, run `nix flake lock` only after adding an input; otherwise just re-enter with `nix develop`.

## Handling `experimental-features`

Flakes may require opt-in. If an error about experimental features appears, rerun the command with `--extra-experimental-features 'nix-command flakes'`.

## Troubleshooting

Decide and proceed. Ask only before a one-way door, such as changing the pinned nixpkgs of a shared flake.

- Package not found: search again with a broader query, check the binary-to-package name map above, then read the full attribute listing the script prints when `nix search` finds nothing.
- `has an unfree license` error: rerun with `NIXPKGS_ALLOW_UNFREE=1` and `--impure`, and report that the package is unfree.
- `not supported on this system` error: look for an alternative package, else tell the human that no build exists for this platform.
- Download or cache failure: retry once, then report the unreachable host and the command to rerun.
