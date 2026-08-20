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

    # skills
    mattpocock-skills.url = "github:mattpocock/skills/0ab1b63a410a03d3627979a109c8695de27af954";
    mattpocock-skills.flake = false;
    pstack.url = "github:cursor/plugins/51a96e0dd838404da19ba83dc70aa21eef71f868";
    pstack.flake = false;

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
