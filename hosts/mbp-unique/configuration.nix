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

    # everyday apps
    "loom"
    "slack"
    "microsoft-auto-update"
    "microsoft-office-businesspro"
  ];

  # host-specific home-manager configuration
  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [
      "azure-cli"
    ];

    programs = {
      zsh = {
        localVariables = {
          SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };

        initContent = lib.mkOrder 1500 ''
          # Source shell functions
          source ${./shell-functions.sh}
        '';
      };

      git.extraConfig.credential = {
        helper = "osxkeychain";
      };
    };
  };
}
