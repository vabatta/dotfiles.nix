{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  home.file.".claude/skills".source = ../skills;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
