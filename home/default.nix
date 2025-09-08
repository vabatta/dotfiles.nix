{ pkgs, primaryUser, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./ghostty.nix
    ./mise.nix
    ./bat.nix
    ./bottom.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./eza.nix
    ./zoxide.nix
    ./fzf.nix
    ./gpg.nix
    # ./k9s.nix
  ];

  home = {
    username = primaryUser;
    stateVersion = "25.05";
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
      GIT_EDITOR = "vim";
    };

    packages = with pkgs; [
      curl
      fd
      jq
      yq
      entr
      parallel
      noti
      fastfetch
      lesspipe

      # misc
      nixfmt-rfc-style

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
    ];

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
  };
}
