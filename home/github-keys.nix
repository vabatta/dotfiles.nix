{ config, lib, ... }:
let
  cfg = config.github.keys;
in
{
  # GitHub push and signing keys in 1Password, used through its ssh agent (the IdentityAgent of the "*" block).
  # ssh offers GitHub only the push key (IdentitiesOnly, matched by its public key), so the agent never tries the
  # other keys of the vaults; git signs through op-ssh-sign. How often 1Password asks is its own setting: Settings,
  # Developer, SSH Agent, "Remember key approval" (for example "For a set amount of time", 24 hours) and "Approve for
  # all applications" on the prompt. Rotate: a new SSH Key item, update both public keys here, gh ssh-key add <pub>
  # --type authentication|signing, then delete the old GitHub entry.
  options.github.keys = {
    enable = lib.mkEnableOption "GitHub push and signing keys from 1Password through its ssh agent";
    pushPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of the 1Password push item, so ssh offers GitHub only that key.";
    };
    signingPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of the 1Password signing item: user.signingkey and allowed_signers.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".ssh/github_push.pub".text = "${cfg.pushPublicKey}\n";

    programs.ssh.settings."github.com ssh.github.com" = {
      IdentityFile = "~/.ssh/github_push.pub";
      IdentitiesOnly = true;
    };

    programs.git.signing = {
      format = "ssh";
      key = cfg.signingPublicKey;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      signByDefault = true;
    };
    git.allowedSigningKeys = [ cfg.signingPublicKey ];
  };
}
