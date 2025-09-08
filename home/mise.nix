{ pkgs, lib, ... }:
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      experimental = true;
      verbose = false;
      auto_install = true;
    };

    globalConfig = {
      tools = {
        node = [
          "20"
          "22"
        ];
        python = [ "3.13" ];
      };
    };
  };

  # activation script to set up mise configuration
  home.activation.setupMise = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # enable corepack (pnpm, yarn, etc.)
    ${pkgs.mise}/bin/mise set MISE_NODE_COREPACK=true

    # install versions
    ${pkgs.mise}/bin/mise install
  '';
}
