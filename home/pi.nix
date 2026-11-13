{
  ai,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi ];

  # Pi reads skills from ~/.agents/skills (deployed by zed.nix) and rules from here.
  # NOTE: pi is outside the skills host contract (ai/skills/AGENTS.md): it has no MCP, so no Engram,
  # and no subagents. Skills that save to Engram or fan out do not work in pi.
  home.file.".pi/agent/AGENTS.md".source = ai.rules;
}
