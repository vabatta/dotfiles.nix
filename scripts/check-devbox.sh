#!/usr/bin/env bash
# Evaluates nixosModules.devbox on a throwaway x86_64-linux host, so a profile change can be checked
# without a real machine. --build also builds it (needs Linux or an x86_64-linux builder).
# Usage: scripts/check-devbox.sh [--build]
set -euo pipefail
cd "$(dirname "$0")/.."
expr='
  let
    flake = builtins.getFlake (toString ./.);
    host = flake.inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        flake.nixosModules.devbox
        {
          networking.hostName = "devbox-check";
          boot.loader.systemd-boot.enable = true;
          fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
          system.stateVersion = "26.05";
        }
      ];
    };
  in host.config.system.build.toplevel'
if [ "${1:-}" = "--build" ]; then
  nix build --impure --no-link --print-out-paths --expr "$expr"
else
  nix eval --impure --raw --expr "($expr).drvPath"
  echo
fi
