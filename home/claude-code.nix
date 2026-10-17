{ ai, pkgs, inputs, ... }:
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    package = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    skills = ai.skills;
    agentsDir = ai.agents;
  };

  home.file.".claude/CLAUDE.md".source = ai.rules;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
