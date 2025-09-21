{ lib, pkgs, ... }:
# TODO: adjust vivid themes to modern cattppuccin colors
let
  themeFunc = lib.mkOrder 1500 ''
    theme_ls_colors() {
      local theme="$1"
      case "$theme" in
        mocha)     export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-mocha)" ;;
        latte)     export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-latte)" ;;
        frappe)    export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-frappe)" ;;
        macchiato) export LS_COLORS="$(${lib.getExe pkgs.vivid} generate catppuccin-macchiato)" ;;
        *) unset LS_COLORS ;;
      esac
    }

    THEME_FUNCS+=("theme_ls_colors")
  '';
in
{
  programs.vivid = {
    enable = true;
  };

  programs.zsh.initContent = themeFunc;
}
