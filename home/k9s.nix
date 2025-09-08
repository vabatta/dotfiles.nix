{
  pkgs,
  lib,
  config,
  ...
}:
let
  catppuccinK9S = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
    sha256 = "0cs7j1z0xq66w0700qcrc6ynzmw3bdr422p1rnkl7hxq8g4a67zn";
  };
in
{
  programs.k9s = {
    enable = true;

    skins = {
      catppuccin-latte = "${catppuccinK9S}/dist/catppuccin-latte.yaml";
      catppuccin-frappe = "${catppuccinK9S}/dist/catppuccin-frappe.yaml";
      catppuccin-macchiato = "${catppuccinK9S}/dist/catppuccin-macchiato.yaml";
      catppuccin-mocha = "${catppuccinK9S}/dist/catppuccin-mocha.yaml";
    };
  };

  # home.file."${config.xdg.configHome}/k9s/skins".source = "${catppuccinK9S}/dist";

  programs.zsh.initContent = lib.mkOrder 1500 ''
    theme_k9s() {
      local theme="$1"
      local cfg="${config.xdg.configHome}/k9s/skins/catppuccin-$theme.yaml"

      if [[ -f "$cfg" ]]; then
        export K9S_SKIN="catppuccin-$theme"
      else
        unset K9S_SKIN
      fi
    }

    THEME_FUNCS+=("theme_k9s")
  '';
}
