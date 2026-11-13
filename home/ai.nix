{ pkgs, lib, config, ... }:
let
  validate-mermaid = pkgs.buildNpmPackage {
    pname = "validate-mermaid";
    version = "1.0.0";
    src = ../ai/skills/mermaid/scripts;
    npmDepsHash = "sha256-JYjlRn+c5kCnkILkOjBG3rYmhJ5AwghZflMjmY3CIu0=";
    dontNpmBuild = true;
  };

  engram = pkgs.callPackage ./packages/engram.nix { };

  engramServer = {
    command = "${engram}/bin/engram";
    args = [ "mcp" "--tools=agent" ];
    env.ENGRAM_NO_UPDATE_CHECK = "1";
  };

  # carries the engram server itself: its hooks only match mcp__plugin_engram_engram__ tool names
  engramClaudePlugin = pkgs.runCommand "engram-claude-plugin" { } ''
    cp -R ${engram.source}/plugin/claude-code "$out"
    chmod -R u+w "$out"
    cp ${(pkgs.formats.json { }).generate "engram-mcp.json" { mcpServers.engram = engramServer // { type = "stdio"; }; }} "$out/.mcp.json"
  '';

  bundle = name: source: pkgs.runCommand name { } ''
    mkdir -p "$out"
    cp -RL ${source}/. "$out/"
    chmod -R u+w "$out"
  '';
in
{
  options.ai.mcp.remote = lib.mkEnableOption "the remote OAuth MCP servers (Cloudflare, OpenRouter)";

  config = {
    home.packages = [ validate-mermaid engram ];
    home.sessionVariables.ENGRAM_NO_UPDATE_CHECK = "1";
    # slim: the session-start hook skips the protocol text the engram server already sends
    home.file.".engram/protocol-mode.json".text = builtins.toJSON { claude-code = "slim"; };

    programs.mcp = {
      enable = true;
      servers = {
        engram = engramServer;

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

    programs.claude-code = {
      mcpServers = lib.removeAttrs config.programs.mcp.servers [ "engram" ];
      plugins.engram = engramClaudePlugin;
    };

    _module.args.ai = {
      skills = bundle "ai-skills" ../ai/skills;
      agents = bundle "ai-agents" ../ai/agents;
      plugins = pkgs.runCommand "ai-plugins" { } ''
        mkdir -p "$out"
        cp -RL ${../ai/plugins}/. "$out/"
        cp ${engram.source}/plugin/opencode/engram.ts "$out/engram.ts"
      '';
      rules = ../ai/AGENTS.md;
    };
  };
}
