{
  pkgs,
  lib,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp";

  # host-specific homebrew casks
  homebrew.casks = [
    "container"
  ];

  # host-specific home-manager configuration
  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [

    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        # Source shell functions
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        userName = "vabatta";
        userEmail = "2137077+vabatta@users.noreply.github.com";
        signing = {
          format = "ssh";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFqyE4flUaslGeGLB/O0KXoPfi+Azp35X8UJ0oAE3U";
          signByDefault = true;
        };
        extraConfig.credential.helper = "osxkeychain";
      };
    };
  };
}
