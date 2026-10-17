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

    # opencode >= 1.18.25 shows a blank TUI when a legacy opencode.db exists; pinned to 1.18.18
    nixpkgs-opencode.url = "github:nixos/nixpkgs/174eb786fb68e3a13e4e535a3deea479a0c07a6a";
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
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      checks.aarch64-darwin.skills =
        pkgs.runCommand "check-skills"
          {
            nativeBuildInputs = [ pkgs.bash ];
          }
          ''
            bash ${./scripts/check-skills.sh} ${./ai/skills} ${./ai/AGENTS.md} ${./ai/skills-guide.html}
            touch $out
          '';

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
