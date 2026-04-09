{
  pkgs,
  lib,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp-unique";

  # host-specific homebrew casks
  homebrew.casks = [
    # devtools
    "devtunnel"
    "docker-desktop"
    "mongodb-compass"
    "openlens"
    "google-chrome"
    "cursor"

    # everyday apps
    "loom"
    "slack"
  ];

  homebrew.masApps = {
    "Tailscale" = 1475387142;
  };

  # host-specific home-manager configuration
  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [
      azure-cli
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        # Source shell functions
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        signing = {
          format = "ssh";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZjJGPFzlFedQFJ2ez8DwQS8SuiNFeXNFUSwtl+w892";
          signByDefault = true;
        };
        settings.credential.helper = "osxkeychain";
      };
    };
  };
}
