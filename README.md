# Nix macOS Dotfiles

My personal macOS dotfiles managed declaratively with Nix flakes through nix-darwin backed by home-manager.

## Folder Structure

```
nix/
├── flake.nix                 # Main flake config
├── darwin/                  # macOS system settings
│   ├── default.nix
│   ├── settings.nix
│   └── homebrew.nix
├── home/                    # Home Manager config
│   ├── default.nix          # contains non-configured packages as well
│   ├── shell.nix
│   └── <program>.nix
└── hosts/
    └── mbp/
        ├── configuration.nix
        └── shell-functions.sh
```

## Usage

1. Install Nix ([docs](https://docs.determinate.systems/#products))
2. Clone this repo to `~/.config/nix`
3. Edit names/usernames around (eg. `flake.nix` and `home/git.nix`)
4. Run:  
    ```bash
    darwin-rebuild switch --flake .#mbp
    ```
5. Or nix-darwin directly for the first time run:  
    ```bash
    sudo nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix
    ```

## Customization

- CLI tools: `home/default.nix`
- GUI apps: `darwin/homebrew.nix`
- Host config: `hosts/mbp/configuration.nix`

## Help

See [Nix manual](https://nixos.org/manual/nix/stable/).
Original files from [bgub](https://github.com/bgub/nix-macos-starter).
