{ ai, pkgs, lib, config, inputs, ... }:
let
  vault = config.opencode.opVault;
  opencode = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

  # The key stays outside the Nix store and reaches OpenCode at launch: an already-set variable wins
  # (hosts without 1Password export it), otherwise the host's 1Password vault supplies it.
  # A host with no vault set never calls op.
  # FIXME: the wrapper also works around a bin/opencode collision and the Home Manager
  # null-package bug. Pass the package directly once both are gone.
  opencodeWrapped = pkgs.writeShellScriptBin "opencode" ''
    ${lib.optionalString (vault != null) ''export OPENROUTER_API_KEY="''${OPENROUTER_API_KEY:-$(${pkgs._1password-cli}/bin/op read 'op://${vault}/OpenRouter - opencode/credential' --no-newline)}"''}
    exec ${opencode}/bin/opencode "$@"
  '';

in
{
  options.opencode.opVault = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "1Password vault that holds this host's OpenRouter key.";
  };

  config = {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      package = opencodeWrapped;

      settings = {
        # Updates are managed by Nix, not OpenCode's self-updater.
        autoupdate = false;
        permission = "allow";
      };

      tui = {
        # Follow macOS appearance automatically instead of the themeup/PI_THEME hook.
        theme = "system";

        plugin = [
          "opencode-bytheway@0.8.0" # btw
          "opencode-session-recall@2.1.0" # memory/history lookups
        ];
      };

      # `skills` must receive a path string; passing the derivation directly recurses.
      skills = toString ai.skills;
    };

    home.file.".config/opencode/agents".source = ai.agents;
    home.file.".config/opencode/plugins".source = ai.plugins;
    home.file.".config/opencode/AGENTS.md".source = ai.rules;

    home.shellAliases = {
      oc = "opencode";
    };
  };
}
