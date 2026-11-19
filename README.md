# Nix macOS Dotfiles

My personal dotfiles managed declaratively with Nix flakes: macOS through nix-darwin, the Linux devbox through NixOS, both backed by home-manager.

## Folder Structure

```
nix/
├── flake.nix                 # main flake config
├── darwin/                  # macOS system settings
│   ├── default.nix
│   ├── settings.nix
│   └── homebrew.nix
├── nixos/                   # NixOS system settings (devbox profile)
│   ├── default.nix
│   └── devbox.nix
├── home/                    # Home Manager config (shared by macOS and NixOS)
│   ├── default.nix          # contains non-explicitly configured packages as well
│   └── <program>.nix
├── scripts/                 # custom shell scripts
│   └── <script>.sh
└── hosts/
    └── <name>/              # host to configure
        └── configuration.nix
```

## Usage

1. Install Nix ([docs](https://docs.determinate.systems/#products))
2. Clone this repo to `~/.config/nix`
3. Edit names/usernames around (eg. `flake.nix` and `home/git.nix`)
4. Run:  
    ```bash
    darwin-rebuild switch --flake .#<name>
    ```
5. Or nix-darwin directly for the first time run:  
    ```bash
    sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix
    ```

### NixOS devbox

The devbox setup is the module `nixosModules.devbox` (`nixos/default.nix` and `nixos/devbox.nix`): user, home-manager, Tailscale, ssh and the T3 server. It has no machine details. A real machine is a separate flake that imports it and adds the host name, boot, disks, network and keys:

```nix
inputs.dotfiles.url = "github:vabatta/dotfiles.nix";
# ...
nixosConfigurations.<host> = dotfiles.inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ dotfiles.nixosModules.devbox ./configuration.nix ];
};
```

Check a profile change without a machine: `scripts/check-devbox.sh` evaluates it on a throwaway host, and `--build` also builds it (needs Linux or an x86_64-linux builder).

1. Create keys on the box, never copy private keys from a laptop: `ssh-keygen -t ed25519 -C devbox` for push, and `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_signing -C "devbox signing"` for commit signing.
2. Add each key to GitHub once, for its own job: `gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title devbox` and `gh ssh-key add ~/.ssh/id_ed25519_signing.pub --type signing --title "devbox signing"`. Set the host's `programs.git.signing.key` to `~/.ssh/id_ed25519_signing.pub` and put the public key in `git.allowedSigningKeys`. GitHub keeps older commits verified after their key is removed; keep the old public key in `git.allowedSigningKeys` so they also verify locally.
3. Allow your laptop to log in: run `ssh-copy-id <user>@devbox` from the laptop.

The box has no 1Password. Export `OPENROUTER_API_KEY` in the environment that starts `opencode`; the wrapper in `home/opencode.nix` uses `op` only when it is unset.

## Customization

- CLI tools: `home/default.nix`
- GUI apps: `darwin/homebrew.nix`
- Host config: `hosts/<name>/configuration.nix`

## Help

See [Nix manual](https://nixos.org/manual/nix/stable/).
Original files from [bgub](https://github.com/bgub/nix-macos-starter).
