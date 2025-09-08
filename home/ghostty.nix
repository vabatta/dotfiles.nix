{ config, ... }:
{
  # Ghostty is managed via brew
  home.file."${config.xdg.configHome}/ghostty/config".text = ''
    theme = "light:catppuccin-latte,dark:catppuccin-mocha"
    font-family = "FiraCode Nerd Font"
  '';
}
