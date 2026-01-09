{ config, ... }:
{
  programs.eza = {
    enable = true;

    colors = "auto";
    icons = "auto";
    git = true;
  };
  home.shellAliases.tree = "eza --tree";

  home.sessionVariables.EZA_CONFIG_DIR = "${config.xdg.configHome}/eza";
}
