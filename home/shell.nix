{ lib, ... }:
let
  zshSettings = lib.mkOrder 500 ''
    # matches case insensitive for lowercase
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    # pasting with tabs doesn't perform completion
    zstyle ':completion:*' insert-tab pending
    # default to file completion
    zstyle ':completion:*' completer _expand _complete _files _correct _approximate
    # enable verbose mode for zsh completion system.
    zstyle ':completion:*' verbose yes
    # set the format for completion descriptions with bold formatting.
    zstyle ':completion:*:descriptions' format '%B%d%b'
    # set the format for messages shown during completion.
    zstyle ':completion:*:messages' format '%d'
    # customize the format of warnings when no matches are found.
    zstyle ':completion:*:warnings' format 'No matches for: %d'
    # disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false
  '';

  themeFunc = lib.mkOrder 500 ''
    # theme function
    typeset -ga THEME_FUNCS

    themeup() {
      local theme="$1"
      local accent="$2"

      # Auto-detect if no args and running on macOS
      if [[ -z "$theme" ]]; then
        if [[ "$OSTYPE" == darwin* ]]; then
          local appearance
          appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

          case "$appearance" in
            Dark) theme="mocha" ;;
            Light) theme="latte" ;;
            *) theme="latte" ;; # fallback
          esac

          accent="blue" # could be made dynamic later
        else
          echo "Usage: themeup <theme> <accent>" >&2
          return 1
        fi
      fi

      if [[ -z "$accent" ]]; then
        echo "Usage: themeup <theme> <accent>" >&2
        return 1
      fi

      for func in "''${THEME_FUNCS[@]}"; do
        if whence -w "$func" >/dev/null; then
          # echo "→ $func $theme $accent"
          "$func" "$theme" "$accent"
        else
          # echo "⚠️ $func not defined"
        fi
      done
    }
  '';

  zshHighlightTheme = lib.mkOrder 1500 ''
    theme_zsh_highlight() {
      local theme="$1"

      case "$theme" in
        "mocha")
          # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
          #
          ## General
          ### Diffs
          ### Markup
          ## Classes
          ## Comments
          ZSH_HIGHLIGHT_STYLES[comment]='fg=#585b70'
          ## Constants
          ## Entitites
          ## Functions/methods
          ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
          ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'
          ## Keywords
          ## Built ins
          ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a6e3a1'
          ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6e3a1'
          ## Punctuation
          ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#f38ba8'
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f38ba8'
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#f38ba8'
          ## Serializable / Configuration Languages
          ## Storage
          ## Strings
          ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#f9e2af'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#f9e2af'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#eba0ac'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#eba0ac'
          ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#f9e2af'
          ## Variables
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#eba0ac'
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[assign]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#cdd6f4'
          ## No category relevant in spec
          ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#eba0ac'
          ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd6f4,underline'
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f38ba8,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cdd6f4,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f38ba8,underline'
          ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
          #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#eba0ac'
          ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
          ZSH_HIGHLIGHT_STYLES[cursor]='fg=#cdd6f4'
        ;;
        "latte")
          # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
          #
          ## General
          ### Diffs
          ### Markup
          ## Classes
          ## Comments
          ZSH_HIGHLIGHT_STYLES[comment]='fg=#acb0be'
          ## Constants
          ## Entitites
          ## Functions/methods
          ZSH_HIGHLIGHT_STYLES[alias]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[function]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[command]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[precommand]='fg=#40a02b,italic'
          ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fe640b,italic'
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fe640b'
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fe640b'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#8839ef'
          ## Keywords
          ## Built ins
          ZSH_HIGHLIGHT_STYLES[builtin]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#40a02b'
          ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#40a02b'
          ## Punctuation
          ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#d20f39'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#d20f39'
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d20f39'
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d20f39'
          ## Serializable / Configuration Languages
          ## Storage
          ## Strings
          ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#df8e1d'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#df8e1d'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#df8e1d'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#e64553'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#df8e1d'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#e64553'
          ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#df8e1d'
          ## Variables
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#e64553'
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[assign]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#4c4f69'
          ## No category relevant in spec
          ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e64553'
          ZSH_HIGHLIGHT_STYLES[path]='fg=#4c4f69,underline'
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#d20f39,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#4c4f69,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#d20f39,underline'
          ZSH_HIGHLIGHT_STYLES[globbing]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#8839ef'
          #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#e64553'
          ZSH_HIGHLIGHT_STYLES[redirection]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[arg0]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[default]='fg=#4c4f69'
          ZSH_HIGHLIGHT_STYLES[cursor]='fg=#4c4f69'
        ;;
        "frappe")
          # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
          #
          ## General
          ### Diffs
          ### Markup
          ## Classes
          ## Comments
          ZSH_HIGHLIGHT_STYLES[comment]='fg=#626880'
          ## Constants
          ## Entitites
          ## Functions/methods
          ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[function]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[command]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6d189,italic'
          ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#ef9f76,italic'
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ef9f76'
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ef9f76'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ca9ee6'
          ## Keywords
          ## Built ins
          ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a6d189'
          ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6d189'
          ## Punctuation
          ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#e78284'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#e78284'
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#e78284'
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#e78284'
          ## Serializable / Configuration Languages
          ## Storage
          ## Strings
          ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#e5c890'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#e5c890'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e5c890'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#ea999c'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e5c890'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#ea999c'
          ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#e5c890'
          ## Variables
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#ea999c'
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[assign]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#c6d0f5'
          ## No category relevant in spec
          ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ea999c'
          ZSH_HIGHLIGHT_STYLES[path]='fg=#c6d0f5,underline'
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#e78284,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#c6d0f5,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#e78284,underline'
          ZSH_HIGHLIGHT_STYLES[globbing]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ca9ee6'
          #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#ea999c'
          ZSH_HIGHLIGHT_STYLES[redirection]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[default]='fg=#c6d0f5'
          ZSH_HIGHLIGHT_STYLES[cursor]='fg=#c6d0f5'
        ;;
        "macchiato")
          # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
          #
          ## General
          ### Diffs
          ### Markup
          ## Classes
          ## Comments
          ZSH_HIGHLIGHT_STYLES[comment]='fg=#5b6078'
          ## Constants
          ## Entitites
          ## Functions/methods
          ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[function]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[command]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6da95,italic'
          ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#f5a97f,italic'
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f5a97f'
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f5a97f'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#c6a0f6'
          ## Keywords
          ## Built ins
          ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a6da95'
          ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6da95'
          ## Punctuation
          ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ed8796'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ed8796'
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ed8796'
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ed8796'
          ## Serializable / Configuration Languages
          ## Storage
          ## Strings
          ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#eed49f'
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#eed49f'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#eed49f'
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#ee99a0'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#eed49f'
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#ee99a0'
          ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#eed49f'
          ## Variables
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#ee99a0'
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[assign]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#cad3f5'
          ## No category relevant in spec
          ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ee99a0'
          ZSH_HIGHLIGHT_STYLES[path]='fg=#cad3f5,underline'
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ed8796,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cad3f5,underline'
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ed8796,underline'
          ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#c6a0f6'
          #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
          #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#ee99a0'
          ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[default]='fg=#cad3f5'
          ZSH_HIGHLIGHT_STYLES[cursor]='fg=#cad3f5'
        ;;
      esac
    }

    THEME_FUNCS+=("theme_zsh_highlight")
  '';

  themeRun = lib.mkOrder 1500 ''
    # Run themeing
    themeup
  '';
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "la" = "ls -lah";
      "ll" = "ls -lh";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cdp" = "cd ~/Projects";
      "cdd" = "cd ~/Downloads";
      "g" = "git";
      "k" = "kubectl";
      "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
    };

    localVariables = {
      REPORTTIME = 10; # display how long all tasks over 10 seconds take
      KEYTIMEOUT = 1; # 10ms delay for key sequences
    };

    # setOptions = [];

    # siteFunctions = {
    #   mkcd = ''
    #     mkdir --parents "$1" && cd "$1"
    #   '';
    # };

    initContent = lib.mkMerge [
      zshSettings
      themeFunc
      zshHighlightTheme
      themeRun
    ];
  };

  # programs.starship = {
  #   enable = true;
  #   settings = {
  #     add_newline = false;
  #     character = {
  #       success_symbol = "[λ](bold green)";
  #       error_symbol = "[λ](bold red)";
  #     };
  #   };
  # };
}
