{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.github.keys;
  home = config.home.homeDirectory;
  sock = "${home}/.ssh/github-agent.sock";
  pushPub = ".ssh/github_push.pub";
  signingPub = ".ssh/github_signing.pub";

  # Both private keys go from 1Password straight into the private agent's memory, never to disk.
  # The retry covers login, when 1Password may not be running or unlocked yet.
  load = pkgs.writeShellScriptBin "github-keys-load" ''
    set -uo pipefail
    export SSH_AUTH_SOCK=${sock}
    read_key() { ${pkgs._1password-cli}/bin/op read "op://${cfg.vault}/$1/private key?ssh-format=openssh"; }

    for _ in $(seq 30); do
      [ -S "$SSH_AUTH_SOCK" ] && break
      sleep 1
    done

    for attempt in $(seq 12); do
      if push=$(read_key ${lib.escapeShellArg cfg.pushItem}) && signing=$(read_key ${lib.escapeShellArg cfg.signingItem}); then
        ${pkgs.openssh}/bin/ssh-add -q -D
        printf '%s\n' "$push" | ${pkgs.openssh}/bin/ssh-add -q - &&
          printf '%s\n' "$signing" | ${pkgs.openssh}/bin/ssh-add -q - &&
          exit 0
      fi
      echo "github-keys-load: attempt $attempt failed, retrying" >&2
      sleep 10
    done
    exit 1
  '';
in
{
  options.github.keys = {
    enable = lib.mkEnableOption "GitHub push and signing keys from 1Password, served by a private ssh-agent";
    vault = lib.mkOption {
      type = lib.types.str;
      description = "ID of the 1Password vault that holds both SSH Key items.";
    };
    pushItem = lib.mkOption {
      type = lib.types.str;
      description = "1Password SSH Key item for GitHub authentication (push).";
    };
    signingItem = lib.mkOption {
      type = lib.types.str;
      description = "1Password SSH Key item for git commit signing.";
    };
    pushPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of pushItem, so ssh picks it from the agent.";
    };
    signingPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of signingItem, used as user.signingkey and in allowed_signers.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ load ];
    home.file.${pushPub}.text = "${cfg.pushPublicKey}\n";
    home.file.${signingPub}.text = "${cfg.signingPublicKey}\n";

    # The agent holds keys only in memory: after it restarts (or a switch reloads it), run github-keys-load.
    launchd.agents.github-ssh-agent = {
      enable = true;
      config = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "rm -f ${sock}; exec ${pkgs.openssh}/bin/ssh-agent -D -a ${sock}"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    launchd.agents.github-keys-load = {
      enable = true;
      config = {
        ProgramArguments = [ "${load}/bin/github-keys-load" ];
        RunAtLoad = true;
        StandardErrorPath = "${home}/Library/Logs/github-keys-load.log";
      };
    };

    # Every other host keeps the 1Password agent from the "*" block.
    programs.ssh.settings."github.com ssh.github.com" = {
      IdentityAgent = sock;
      IdentitiesOnly = true;
      IdentityFile = "~/${pushPub}";
    };

    programs.git.signing = {
      format = "ssh";
      key = "${home}/${signingPub}";
      signer = "${pkgs.writeShellScript "ssh-keygen-github-agent" ''
        SSH_AUTH_SOCK=${sock} exec ${pkgs.openssh}/bin/ssh-keygen "$@"
      ''}";
      signByDefault = true;
    };
    git.allowedSigningKeys = [ cfg.signingPublicKey ];
  };
}
