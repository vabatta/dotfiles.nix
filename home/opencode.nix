{ ai, pkgs, inputs, ... }:
let
  opencode = inputs.nixpkgs-opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode;

  # 1Password stays outside the Nix store while OpenCode receives the key at launch.
  # The wrapper avoids a bin/opencode collision and the Home Manager null-package bug.
  opencodeWrapped = pkgs.writeShellScriptBin "opencode" ''
    export OPENROUTER_API_KEY="$(${pkgs._1password-cli}/bin/op read 'op://Development/OpenRouter API Key - opencode/credential' --no-newline)"
    export ISOQUANT_API_KEY="$(${pkgs._1password-cli}/bin/op read 'op://Development/Isoquant API Key/credential' --no-newline)"
    exec ${opencode}/bin/opencode "$@"
  '';

in
{
  config = {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      package = opencodeWrapped;

      settings = {
        # Updates are managed by Nix, not OpenCode's self-updater.
        autoupdate = false;
        permission = "allow";

        model = "isoquant/glm-5.3-flash";
        provider.isoquant = {
          npm = "@ai-sdk/openai-compatible";
          name = "Isoquant";
          options = {
            baseURL = "https://api.isoquant.ai/v1";
            apiKey = "{env:ISOQUANT_API_KEY}";
            headers."Isoquant-ZDR" = "required";
          };
          models."glm-5.3-flash" = {
            name = "GLM-5.3-Flash";
            tool_call = true;
            reasoning = true;
            interleaved.field = "reasoning_content";
            cost = {
              input = 0.07;
              output = 0.20;
              cache_read = 0.014;
            };
            limit = {
              context = 1048576;
              output = 1048576;
            };
          };
        };
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
