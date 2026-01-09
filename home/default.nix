{
  pkgs,
  hostUsername,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./vivid.nix
    ./ghostty.nix
    ./gpg.nix
    ./ssh.nix
    ./git.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./less.nix
    ./fzf.nix
    ./bat.nix
    ./eza.nix
    ./zoxide.nix
    ./nvim.nix
    ./claude-code.nix
    ./bottom.nix
    # ./k9s.nix
  ];

  home = {
    username = hostUsername;
    stateVersion = "25.05";
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less";
      EDITOR = "vim";
      VISUAL = "vim";
      GIT_EDITOR = "vim";
    };

    shellAliases = {
      "la" = "ls -lah";
      "ll" = "ls -lh";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cdp" = "cd ~/Projects";
      "cdd" = "cd ~/Downloads";
      "k" = "kubectl";
      "nd" = "nix develop";
      "ns" = "nix-shell";
      "nsz" = "nix-shell --run 'exec zsh'";
      "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
    };

    packages = with pkgs; [
      curl
      fx
      entr
      parallel
      noti
      fastfetch
      oha
      kubectl
      _1password-cli

      # misc
      nixfmt-rfc-style

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack
    ];

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
  };
}
