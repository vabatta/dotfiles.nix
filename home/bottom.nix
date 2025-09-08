{
  pkgs,
  lib,
  config,
  ...
}:

let
  catppuccinBottom = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bottom";
    rev = "eadd75acd0ecad4a58ade9a1d6daa3b97ccec07c";
    sha256 = "16ba69j4n4qca1zb2qvcggxja69jxwcjh0v08ijhvfpl9rva9yvm";
  };
in
{
  programs.bottom = {
    enable = true;
  };

  home.file."${config.xdg.configHome}/bottom/themes".source = "${catppuccinBottom}/themes";

  programs.zsh.initContent = lib.mkOrder 1500 ''
    theme_bottom() {
      local theme="$1"
      local cfg="${config.xdg.configHome}/bottom/themes/$theme.toml"
      # ignore accent

      if [[ -f "$cfg" ]]; then
        export BTM_CONFIG_FILE="$cfg"
        alias btm="btm -C $BTM_CONFIG_FILE"
      else
        unalias btm 2>/dev/null
      fi
    }

    THEME_FUNCS+=("theme_bottom")
  '';
}
