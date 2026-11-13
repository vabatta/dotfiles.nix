# The devbox profile: what every devbox runs, whatever the machine. A host adds its name, boot, disks, network and keys.
# Exported as nixosModules.devbox, so a private flake can build a real machine on top of it.
{
  lib,
  pkgs,
  inputs,
  hostUsername,
  ...
}:
let
  t3code = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code;
in
{
  # keep the user's systemd services (T3 server) running without a login
  users.users.${hostUsername}.linger = true;

  # macOS ships python3 with the Xcode command line tools; NixOS does not, and skill-creator needs it
  environment.systemPackages = [ pkgs.python3 ];

  services.openssh.enable = true;
  services.tailscale.enable = true;

  # the T3 server is reachable over the tailnet only; the LAN and WAN stay closed
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3773 ];

  home-manager.users.${hostUsername} = {
    ai.mcp.remote = true;

    xdg.enable = true;
    home.preferXdgDirectories = true;
    opencode.opVault = "Devbox";

    # headless T3 server for the Mac app; updated with `nix flake update llm-agents`, not `t3 update`
    systemd.user.services.t3 = {
      Unit.Description = "T3 Code server";
      Service = {
        ExecStart = "${t3code}/bin/t3 serve --lan --port 3773 --no-browser";
        Environment = [
          "PATH=/etc/profiles/per-user/${hostUsername}/bin:/run/current-system/sw/bin"
          "T3CODE_TELEMETRY_ENABLED=false"
        ];
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
      };
    };
  };
}
