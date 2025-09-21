{
  pkgs,
  lib,
  config,
  ...
}:
let
  catppuccinEza = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "eza";
    rev = "70f805f6cc27fa5b91750b75afb4296a0ec7fec9";
    sha256 = "09yd4813g1wm43qdyxi0xsc26p2bbchicbhnwx700hayhknb9q23";
  };

  themeFunc = lib.mkOrder 1500 ''
    theme_eza() {
      local theme="$1"
      local accent="$2"
      local cfg="${config.xdg.configHome}/eza/themes/$theme/catppuccin-$theme-$accent.yml"
      local target="${config.xdg.configHome}/eza/theme.yml"

      if [[ -f "$cfg" ]]; then
        mkdir -p "$(dirname "$target")"
        ln -sf "$cfg" "$target"
      else
        rm -f "$target"
      fi
    }

    THEME_FUNCS+=("theme_eza")
  '';
in
{
  programs.eza = {
    enable = true;

    colors = "auto";
    icons = "auto";
    git = true;
  };

  home.file."${config.xdg.configHome}/eza/themes".source = "${catppuccinEza}/themes";
  home.sessionVariables.EZA_CONFIG_DIR = "${config.xdg.configHome}/eza";

  programs.zsh.initContent = themeFunc;
}
