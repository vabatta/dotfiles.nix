{
  pkgs,
  lib,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp";

  homebrew.casks = [
    "docker-desktop"
    "local/container/container"
    "local/davit/davit"
  ];

  homebrew.taps = [
    "local/container"
    "local/davit"
  ];

  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [
      # claude-code-acp
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

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
