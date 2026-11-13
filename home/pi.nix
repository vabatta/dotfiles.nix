{
  ai,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi ];

  # Pi reads skills from ~/.agents/skills (deployed by zed.nix) and rules from here.
  # NOTE: outside the skills host contract (no MCP, no subagents), so Engram and fan-out skills fail here
  home.file.".pi/agent/AGENTS.md".source = ai.rules;
}
