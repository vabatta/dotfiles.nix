{
  description = "My system configuration";
  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
