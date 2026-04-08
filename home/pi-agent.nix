{ pkgs, ... }:
{
  # Pi coding agent - minimal code harness
  # Config lives in ~/.pi/agent/ (not nixified — see CLAUDE.md for rationale)
  # - models.json: API providers and model configuration
  # - settings.json: defaults (defaultProvider, defaultModel, theme, etc.)
  # - AGENTS.md: global context/conventions
  # - SYSTEM.md: custom system prompt (optional)

  home.packages = [
    (pkgs.callPackage ../pkgs/pi-agent.nix { })
  ];
}
