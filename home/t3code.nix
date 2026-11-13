{ ... }:
{
  # NOTE: the Mac uses the t3-code cask, because nixpkgs t3code is not in the binary cache
  home.sessionVariables.T3CODE_TELEMETRY_ENABLED = "false";
}
