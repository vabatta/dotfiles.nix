{ config, lib, pkgs, ... }:
let
  catppuccinLazygit = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "lazygit";
    rev = "798ad2e75a11766e9ba50e76e59aea6a81eb4866"; # v2.3.0
    sha256 = "0xj8mz6s0hiyffgj7qm28kbd926qy4li2ga6bwy0mnb2nch9203p";
  };

  themeFunc = lib.mkOrder 1500 ''
    theme_lazygit() {
      local theme="$1"
      local accent="$2"
      local cfg="${config.xdg.configHome}/lazygit/themes/$theme/$accent.yml"

      if [[ -f "$cfg" ]]; then
        export LG_CONFIG_FILE="$cfg"
      else
        unset LG_CONFIG_FILE
      fi
    }

    THEME_FUNCS+=("theme_lazygit")
  '';
in
{
  programs.lazygit = {
    enable = true;
  };

  home.file."${config.xdg.configHome}/lazygit/themes".source = "${catppuccinLazygit}/themes";
  home.shellAliases.lg = "lazygit";

  programs.zsh.initContent = themeFunc;
}
