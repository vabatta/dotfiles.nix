{ ai, config, pkgs, inputs, ... }:
{
  programs.claude-code = {
    enable = true;
    # no enableMcpIntegration: home/ai.nix passes every server except engram, which its plugin brings

    # NOTE: the Home Manager default moves to XDG dirs on a stateVersion bump; CLAUDE.md and T3 read ~/.claude
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
