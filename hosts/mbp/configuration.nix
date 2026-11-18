{
  pkgs,
  lib,
  inputs,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp";

  nix-homebrew.taps."wouterdebie/homebrew-tap" = inputs.homebrew-wouterdebie;
  nix-homebrew.trust.casks = [ "wouterdebie/tap/davit" ];

  homebrew.casks = [
    "docker-desktop"
    "t3-code"
    "wouterdebie/tap/davit"
  ];

  homebrew.taps = [
    "wouterdebie/tap"
  ];

  homebrew.masApps = {
    "Tailscale" = 1475387142;
  };

  home-manager.users.${hostUsername} = {
    ai.mcp.remote = true;

    xdg.enable = true;
    home.preferXdgDirectories = true;
    opencode.opVault = "Macbook Personal";

    home.packages = with pkgs; [
      # claude-code-acp
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs.ssh.settings."*".IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        signing = {
          format = "ssh";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFqyE4flUaslGeGLB/O0KXoPfi+Azp35X8UJ0oAE3U";
          signByDefault = true;
        };
        settings.credential.helper = "osxkeychain";
      };
    };
  };
}
