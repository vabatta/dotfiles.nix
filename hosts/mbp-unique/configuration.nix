{
  pkgs,
  lib,
  inputs,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp-unique";

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

  home-manager.users.${hostUsername} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [
      azure-cli
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.coderabbit-cli
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs.ssh.settings."*".IdentityAgent =
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        # TODO: move GitHub push and signing to home/github-keys.nix (one 1Password approval per login).
        # On this laptop, with its own 1Password account:
        # 1. Create two SSH Key items in one vault (`op vault list` gives its ID):
        #      op item create --category "SSH Key" --ssh-generate-key ed25519 --vault <vault ID> --title "github - mbp-unique push"
        #      op item create --category "SSH Key" --ssh-generate-key ed25519 --vault <vault ID> --title "github - mbp-unique signing"
        # 2. Delete this signing block and set, outside programs:
        #      github.keys = {
        #        enable = true;
        #        vault = "<vault ID>";
        #        pushItem = "github - mbp-unique push";
        #        signingItem = "github - mbp-unique signing";
        #        pushPublicKey = "<op read 'op://<vault ID>/github - mbp-unique push/public key'>";
        #        signingPublicKey = "<op read 'op://<vault ID>/github - mbp-unique signing/public key'>";
        #      };
        #      git.allowedSigningKeys = [ "<the Unique AG key below>" ]; # older commits still verify locally
        # 3. darwin-rebuild switch, then run github-keys-load once.
        # 4. gh ssh-key add <push .pub> --type authentication --title "mbp-unique push"
        #    gh ssh-key add <signing .pub> --type signing --title "mbp-unique signing"
        # 5. Once `ssh -T git@github.com` and a signed commit work, remove both "Unique AG" entries:
        #    gh ssh-key list, then gh ssh-key delete <id> for each.
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
