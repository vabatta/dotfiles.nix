{ pkgs, lib, config, inputs, ... }:
let
  validate-mermaid = pkgs.buildNpmPackage {
    pname = "validate-mermaid";
    version = "1.0.0";
    src = ../ai/skills/mermaid/scripts;
    npmDepsHash = "sha256-JYjlRn+c5kCnkILkOjBG3rYmhJ5AwghZflMjmY3CIu0=";
    dontNpmBuild = true;
  };

  gm = inputs.gm.packages.${pkgs.stdenv.hostPlatform.system}.default;

  bundle = name: sources: pkgs.runCommand name { } ''
    mkdir -p "$out"
    ${lib.concatMapStrings (source: "cp -RL ${source}/. \"$out/\"\n") sources}
    chmod -R u+w "$out"
  '';
in
{
  options.ai.mcp.remote = lib.mkEnableOption "the remote OAuth MCP servers (Cloudflare, OpenRouter)";

  config = {
    home.packages = [ validate-mermaid gm ];

    programs.mcp = {
      enable = true;
      servers = {
        obscura = {
          command = lib.getExe pkgs.obscura;
          args = [ "mcp" ];
        };
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        "1password".command = "/Applications/1Password.app/Contents/MacOS/1password-mcp";
      }
      // lib.optionalAttrs config.ai.mcp.remote {
        cloudflare.url = "https://mcp.cloudflare.com/mcp";
        openrouter.url = "https://mcp.openrouter.ai/mcp";
      };
    };

    _module.args.ai = {
      skills = bundle "ai-skills" [ ../ai/skills "${gm}/share/gm/skills" ];
      agents = bundle "ai-agents" [ ../ai/agents ];
      plugins = ../ai/plugins;
      rules = ../ai/AGENTS.md;
    };
  };
}
