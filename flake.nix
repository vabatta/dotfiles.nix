{
  description = "My system configuration";
  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # utility for writing flakes
    flake-utils.url = "github:numtide/flake-utils";

    # declarative nvim config
    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # shell scripts (theme orchestrator)
    scriptorium.url = "github:proventuslabs/scriptorium";
    scriptorium.inputs.nixpkgs.follows = "nixpkgs";

    # claude code CLI
    claude-code.url = "github:sadjow/claude-code-nix";

    # Matt Pocock's agent skills (plain skill files, consumed as a source tree).
    # Pinned to a commit; to bump, edit the ref below and run `nix flake lock`.
    mattpocock-skills.url = "github:mattpocock/skills/43ea0884b07a3e67a5a07f025ce92aefa983177b";
    mattpocock-skills.flake = false;

  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      nvf,
      ...
    }@inputs:
    {
      # build darwin flake using:
      # $ darwin-rebuild build --flake .#<name>

      darwinConfigurations."mbp" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
          ./hosts/mbp/configuration.nix
        ];
        specialArgs = {
          inherit inputs self;
          hostUsername = "yeetus";
        };
      };

      darwinConfigurations."mbp-unique" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin
          ./hosts/mbp-unique/configuration.nix
        ];
        specialArgs = {
          inherit inputs self;
          hostUsername = "vb";
        };
      };

    };
}
