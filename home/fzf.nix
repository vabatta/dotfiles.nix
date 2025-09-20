{ pkgs, lib, ... }:
let
  zshSettings = lib.mkOrder 1000 ''
    # make fzf-tab follow FZF_DEFAULT_OPTS
    # NOTE: this may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'
    # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
    zstyle ':completion:*' menu no

    # use `less` for previewing files (supporting preprocessing with the LESSOPEN environment variable)
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ''${(Q)realpath}'
    # show environment variable value when completing environment variables
    zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${(P)word}'
  '';

  themeFunc = lib.mkOrder 1500 ''
    theme_fzf() {
      local theme="$1"
      # ignore accent
      local colors=""

      case "$theme" in
        mocha)
          colors="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
                  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
                  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
                  --color=selected-bg:#45475a"
          ;;
        latte)
          colors="--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
                  --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
                  --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
                  --color=selected-bg:#bcc0cc"
          ;;
        frappe)
          colors="--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
                  --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
                  --color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
                  --color=selected-bg:#51576d"
          ;;
        macchiato)
          colors="--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
                  --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
                  --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
                  --color=selected-bg:#494d64"
          ;;
      esac

      # remove existing --color options to avoid conflicts
      local cleaned="''${FZF_DEFAULT_OPTS//--color[^ ]*/}"

      export FZF_DEFAULT_OPTS="$cleaned $colors"
    }

    THEME_FUNCS+=("theme_fzf")
  '';
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--style minimal"
      "--layout reverse"
      # "--height -3"
    ];
  };

  programs.zsh.localVariables = {
    # FZF_TMUX_HEIGHT = "-3";
  };

  programs.zsh.plugins = [
    # https://discourse.nixos.org/t/darwin-home-manager-zsh-fzf-and-zsh-fzf-tab/33943/4
    {
      name = "fzf-tab";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "01dad759c4466600b639b442ca24aebd5178e799"; # v1.2.0
        sha256 = "0mnsmfv0bx6np2r6pll43h261v7mh2ic1kd08r7jcwyb5xarfvmb";
      };
    }

    # {
    #   name = "fzf-tab-source";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "Freed-Wu";
    #     repo = "fzf-tab-source";
    #     rev = "a06c2cf1f9b4f1582cb7536ce06f12ba02696ea6"; # latest master 06.09.2025
    #     sha256 = "0is2xqi83k0gbp5sxp407mbhc4rfrnsdagkhdbm45waf13hb2knj";
    #   };
    # }
  ];

  programs.zsh.initContent = lib.mkMerge [
    zshSettings
    themeFunc
  ];
}
