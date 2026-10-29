{
  lib,
  hostUsername,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "devbox";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "25.05";

  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;
    opencode.opVault = "Devbox";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
      };
    };
  };
}
