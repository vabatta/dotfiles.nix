{ ai, pkgs, ... }:
let
  # 1Password stays outside the Nix store while OpenCode receives the key at launch.
  # The wrapper avoids a bin/opencode collision and the Home Manager null-package bug.
  opencodeWrapped = pkgs.writeShellScriptBin "opencode" ''
    export OPENROUTER_API_KEY="$(${pkgs._1password-cli}/bin/op read 'op://Development/OpenRouter API Key/credential' --no-newline)"
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';

in
{
  config = {
    programs.opencode = {
      enable = true;
      package = opencodeWrapped;

      settings = {
        # Updates are managed by Nix, not OpenCode's self-updater.
        autoupdate = false;
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

    home.shellAliases = {
      oc = "opencode";
    };
  };
}
