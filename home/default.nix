{ hostUsername, pkgs, inputs, ... }:
{
  imports = [
    ./bat.nix
    ./bottom.nix
    ./claude-code.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gpg.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./less.nix
    ./nvim.nix
    ./ssh.nix
    ./starship.nix
    ./vivid.nix
    ./zoxide.nix
    ./zsh.nix
    # ./k9s.nix
  ];

  home = {
    username = hostUsername;
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "vim";
      GIT_EDITOR = "vim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less";
      VISUAL = "vim";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "cdd" = "cd ~/Downloads";
      "cdp" = "cd ~/Projects";
      "k" = "kubectl";
      "la" = "ls -lah";
      "ll" = "ls -lh";
      "nd" = "nix develop";
      "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
      "ns" = "nix-shell";
      "nsz" = "nix-shell --run 'exec zsh'";
    };

    packages = with pkgs; [
      _1password-cli
      curl
      entr
      fastfetch
      fx
      kubectl
      noti
      oha
      parallel

      # misc
      nixfmt-rfc-style

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.hack

      # scriptorium (theme, cz, dotenv, jwt)
      inputs.scriptorium.packages.${pkgs.system}.default
    ];

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
  };
}
