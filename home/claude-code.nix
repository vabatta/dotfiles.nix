{ ai, pkgs, inputs, ... }:
{
  home.packages = [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  home.file.".claude/skills".source = ai.skills;
  home.file.".claude/agents".source = ai.agents;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
