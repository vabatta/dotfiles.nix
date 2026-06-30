{ pkgs, inputs, skillsTree, ... }:
{
  home.packages = [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  home.file.".claude/skills".source = skillsTree;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
