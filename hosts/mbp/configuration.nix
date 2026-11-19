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

    github.keys = {
      enable = true;
      vault = "xfii5oabfu3sksmaglachpyy3a"; # Macbook Personal
      pushItem = "github - mbp push";
      signingItem = "github - mbp signing";
      pushPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcFFbuWULh/AS3I2SMR1ugDww3mU5+9maNIxQk+LC89";
      signingPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDn1Nh+Oexkh9cWo6bUCYKRWg0NLnXelge9GB/bihMsN";
    };

    # retired signing keys, so older commits still verify locally
    git.allowedSigningKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlzbJwBmmgZQauXtPJWQe+C5QajgFfCX7wyS6Q8eJAX" # ~/.ssh/id_ed25519_signing
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERFqyE4flUaslGeGLB/O0KXoPfi+Azp35X8UJ0oAE3U" # 1Password "GitHub - CLI & Sign"
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

    # sops runs this only to decrypt, so the homelab admin age key stays in 1Password and in memory.
    home.sessionVariables.SOPS_AGE_KEY_CMD = "op document get 'sops - admin age key' --vault px4vlmp4izi6h7auravxrwcx3a";

    programs.ssh.settings."*".IdentityAgent =
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        settings.credential.helper = "osxkeychain";
      };
    };
  };
}
