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
├── nixos/                   # NixOS system settings (devbox)
│   └── default.nix
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

1. Install NixOS, clone this repo to `~/.config/nix`.
2. Replace the placeholder with the real hardware config:
    ```bash
    nixos-generate-config --show-hardware-config > hosts/devbox/hardware-configuration.nix
    ```
3. Run `sudo nixos-rebuild switch --flake .#devbox`.
4. Create keys on the box, never copy private keys from a laptop: `ssh-keygen -t ed25519 -C devbox`.
5. Add `~/.ssh/id_ed25519.pub` to GitHub twice, as an authentication key and as a signing key.
6. Allow your laptop to log in: run `ssh-copy-id <user>@devbox` from the laptop.

The box has no 1Password. Export `OPENROUTER_API_KEY` in the environment that starts `opencode`; the wrapper in `home/opencode.nix` uses `op` only when it is unset.

## Customization

- CLI tools: `home/default.nix`
- GUI apps: `darwin/homebrew.nix`
- Host config: `hosts/<name>/configuration.nix`

## Help

See [Nix manual](https://nixos.org/manual/nix/stable/).
Original files from [bgub](https://github.com/bgub/nix-macos-starter).
