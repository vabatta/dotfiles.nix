{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];
}
