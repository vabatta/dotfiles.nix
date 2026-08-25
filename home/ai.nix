{ pkgs, ... }:
let
  validate-mermaid = pkgs.buildNpmPackage {
    pname = "validate-mermaid";
    version = "1.0.0";
    src = ../ai/skills/mermaid/scripts;
    npmDepsHash = "sha256-JYjlRn+c5kCnkILkOjBG3rYmhJ5AwghZflMjmY3CIu0=";
    dontNpmBuild = true;
  };

  bundle = name: source: pkgs.runCommand name { } ''
    mkdir -p "$out"
    cp -RL ${source}/. "$out/"
    chmod -R u+w "$out"
  '';
in
{
  home.packages = [ validate-mermaid ];

  _module.args.ai = {
    skills = bundle "ai-skills" ../ai/skills;
    agents = bundle "ai-agents" ../ai/agents;
  };
}
