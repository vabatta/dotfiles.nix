{ ai, config, pkgs, inputs, ... }:
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    # NOTE: pinned against the Home Manager default, which moves to XDG dirs on a stateVersion bump.
    # The CLAUDE.md below and T3's user settings both read ~/.claude.
    configDir = "${config.home.homeDirectory}/.claude";

    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    skills = ai.skills;
    agentsDir = ai.agents;
  };

  home.file.".claude/CLAUDE.md".source = ai.rules;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
