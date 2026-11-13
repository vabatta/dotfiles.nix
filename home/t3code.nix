{ ... }:
{
  # the desktop app and the server read this from the shell profile
  # NOTE: the Mac uses the t3-code Homebrew cask (hosts/mbp), because nixpkgs t3code is not in the
  # binary cache. The devbox runs the server from llm-agents (nixos/devbox.nix).
  home.sessionVariables.T3CODE_TELEMETRY_ENABLED = "false";
}
