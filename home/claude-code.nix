{ ai, config, pkgs, inputs, ... }:
let
  upstream = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
in
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    # NOTE: the Home Manager default moves to XDG dirs on a stateVersion bump; CLAUDE.md and T3 read ~/.claude
    configDir = "${config.home.homeDirectory}/.claude";

    # gm is the memory; set on the binary so GUI-launched T3 sessions get it too
    package = pkgs.symlinkJoin {
      pname = "claude-code";
      inherit (upstream) version meta;
      paths = [ upstream ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm "$out/bin/claude"
        makeWrapper ${upstream}/bin/claude "$out/bin/claude" --set CLAUDE_CODE_DISABLE_AUTO_MEMORY 1
      '';
    };
    skills = ai.skills;
    agentsDir = ai.agents;
  };

  home.file.".claude/CLAUDE.md".source = ai.rules;

  home.shellAliases = {
    "cc" = "claude";
    "ccd" = "claude --dangerously-skip-permissions";
  };
}
