---
source: https://github.com/vabatta/dotfiles.nix/blob/a4e009a74623947a5e6dab841c22b6dcde01dbb1/skills/nixification/SKILL.md
name: nixification
description: Use this skill whenever a required tool, binary, library, or dependency is missing from the current machine. Trigger when you encounter "command not found", missing package errors, unavailable system dependencies, or when the user explicitly says mention nix. Also trigger when the user asks you to create or maintain a flake.nix, set up a reproducible dev environment, or wrap a project in a Nix flake. If you already tried to install something with apt/brew/pip and it failed or is unavailable, and the user tells you to use nix instead, this is your skill. Do NOT trigger for NixOS system configuration, home-manager, or deploying NixOS machines — only for using nix as a dependency/tooling provider.
---

# Nixification

Resolve missing tools and dependencies using Nix, favoring flakes for reproducibility.

## Core Principle

When a dependency is missing, don't just run an ad-hoc `nix shell` one-liner and move on. Prefer creating (or extending) a `flake.nix` so the environment is reproducible. Fall back to ephemeral `nix shell` only for one-off, throwaway commands.

## Decision Flow

1. **Check if a `flake.nix` already exists** in the project root (or the working directory).
   - If yes → read it, add the missing package to `buildInputs`, and enter the environment with `nix develop`.
   - If no → decide whether to create one (see below).

2. **Create a `flake.nix` when:**
   - The task involves more than one dependency.
   - The user is working inside a project directory that will persist.
   - The user explicitly asks for a flake.

3. **Use ephemeral `nix shell` when:**
   - You need a single binary for a one-off command (e.g., `nix shell nixpkgs#jq --command jq '.name' file.json`).
   - The user explicitly asks for a quick/throwaway approach.

## Finding Packages

Apply [Use Before Build](../principle-use-before-build/SKILL.md) before adding a
package. Check the current environment and project dependencies first. Before
assuming a package name, search for it:

```bash
nix search nixpkgs <query> --json 2>/dev/null | head -80
```

If `nix search` is slow or unavailable, fall back to:

```bash
nix eval --expr 'let pkgs = import <nixpkgs> {}; in builtins.attrNames pkgs' --json 2>/dev/null | tr ',' '\n' | grep -i <query>
```

Use the `packages.x86_64-linux` attribute path (adjust arch if needed). Package names in nixpkgs often differ from the binary name — e.g., the `rg` binary is `ripgrep`, `fd` is `fd`, `python3` may be `python3Full` or `python312`.

## Ephemeral Shell (one-off)

Run a single command without persisting anything:

```bash
nix shell nixpkgs#<package> --command <binary> [args...]
```

**Example:** `nix shell nixpkgs#jq --command jq '.version' package.json`

To enter an interactive shell with multiple packages:

```bash
nix shell nixpkgs#jq nixpkgs#ripgrep
```

## Creating a flake.nix

When creating a new flake, use this minimal template:

```nix
{
  description = "<short project description>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add packages here
          ];

          shellHook = ''
            echo "nixification: dev shell ready"
          '';
        };
      });
}
```

After creating or editing `flake.nix`:

```bash
# Generate the lock file
nix flake update

# Enter the dev shell
nix develop
```

If git is in use and `flake.nix` is new, stage it first — Nix flakes require tracked files:

```bash
git add flake.nix flake.lock
```

## Extending an Existing flake.nix

Read the current file, locate the `buildInputs` list, and append the missing package. Do not rewrite unrelated parts of the flake. After editing, run `nix flake update` only if you changed `inputs`; otherwise just re-enter with `nix develop`.

## Handling `experimental-features`

Flakes may require opt-in. If you get an error about experimental features:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Do this once, then retry the command.

## Troubleshooting

Ask the human what to do.
