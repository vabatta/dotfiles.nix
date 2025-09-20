{ pkgs, lib, ... }:
let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
    sha256 = "1y5sfi7jfr97z1g6vm2mzbsw59j1jizwlmbadvmx842m0i5ak5ll";
  };
in
{
  programs.bat = {
    enable = true;

    extraPackages = with pkgs.bat-extras; [
      batpipe
      # batman
      # batdiff
      # batgrep
      # batwatch
    ];

    config = {
      theme-light = "CatppuccinLatte";
      theme-dark = "CatppuccinMocha";
    };

    themes = {
      CatppuccinLatte = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Latte.tmTheme";
      };
      CatppuccinFrappe = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Frappe.tmTheme";
      };
      CatppuccinMocha = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Mocha.tmTheme";
      };
      CatppuccinMacchiato = {
        src = catppuccin-bat;
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'awk '\\''{ gsub(/\\x1B\\[[0-9;]*m/, \\\"\\\", \\$0); gsub(/.\\x08/, \\\"\\\", \\$0); print }'\\'' | bat -p -lman'";
  };

  home.shellAliases = {
    cat = "bat";
  };

  programs.zsh.initContent = lib.mkOrder 1500 ''
    eval "$(batpipe)"

    theme_bat() {
      local theme="$1"
      case "$theme" in
        mocha)     export BAT_THEME="CatppuccinMocha" ;;
        latte)     export BAT_THEME="CatppuccinLatte" ;;
        frappe)    export BAT_THEME="CatppuccinFrappe" ;;
        macchiato) export BAT_THEME="CatppuccinMacchiato" ;;
        *) unset BAT_THEME ;;
      esac
    }

    THEME_FUNCS+=("theme_bat")
  '';
}
