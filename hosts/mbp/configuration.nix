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

  home-manager.users.${hostUsername} = { config, ... }: {
    ai.mcp.remote = true;

    git.allowedSigningKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlzbJwBmmgZQauXtPJWQe+C5QajgFfCX7wyS6Q8eJAX"
      # previous 1Password signing key, so older commits still verify
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFqyE4flUaslGeGLB/O0KXoPfi+Azp35X8UJ0oAE3U"
    ];

    xdg.enable = true;
    home.preferXdgDirectories = true;
    opencode.opVault = "Macbook Personal";

    home.packages = with pkgs; [
      # claude-code-acp
      age
      sops
      ssh-to-age
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs.ssh.settings."*".IdentityAgent =
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}

        # The homelab admin age key lives only in 1Password and reaches sops in memory, per command.
        sops() { SOPS_AGE_KEY="$(op document get 'sops - admin age key' --vault px4vlmp4izi6h7auravxrwcx3a)" command sops "$@"; }
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        # Signing uses an on-disk key and never asks the 1Password agent, which keeps the push key.
        signing = {
          format = "ssh";
          key = "${config.home.homeDirectory}/.ssh/id_ed25519_signing.pub";
          signer = "${pkgs.writeShellScript "ssh-keygen-no-agent" ''
            exec env -u SSH_AUTH_SOCK ${pkgs.openssh}/bin/ssh-keygen "$@"
          ''}";
          signByDefault = true;
        };
        settings.credential.helper = "osxkeychain";
      };
    };
  };
}
