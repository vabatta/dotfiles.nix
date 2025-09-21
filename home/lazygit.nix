{
  pkgs,
  lib,
  config,
  ...
}:
let
  catppuccinLazygit = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "lazygit";
    rev = "c24895902ec2a3cb62b4557f6ecd8e0afeed95d5";
    sha256 = "1fjp1b8s4aa8xi9mpw6h7d0bfx45dqxdjdw428w1fb7h8ww49qp1";
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
