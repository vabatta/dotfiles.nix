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

  bundle = name: source: pkgs.runCommand name { } ''
    mkdir -p "$out"
    cp -RL ${source}/. "$out/"
    chmod -R u+w "$out"
  '';
in
{
  options.ai.mcp.remote = lib.mkEnableOption "the remote OAuth MCP servers (Cloudflare, OpenRouter)";

  config = {
    # the mermaid skill's validator; the other tools the skills assume are listed in ai/skills/AGENTS.md
    home.packages = [ validate-mermaid engram ];
    home.sessionVariables.ENGRAM_NO_UPDATE_CHECK = "1";

    # every MCP server is declared here; Claude Code, opencode, and Zed read them through enableMcpIntegration
    programs.mcp = {
      enable = true;
      servers = {
        # the database stays at ~/.engram, shared by every worktree
        # TODO: keep each repo's memories in the repo (engram sync to .engram/, with git hooks to export
        # and import), decide how public repos are handled, and whether to add the Claude Code plugin.
        engram = {
          command = "${engram}/bin/engram";
          args = [ "mcp" "--tools=agent" ];
          env.ENGRAM_NO_UPDATE_CHECK = "1";
        };

        nixos.command = lib.getExe pkgs.mcp-nixos;

        obscura = {
          command = lib.getExe pkgs.obscura;
          args = [ "mcp" ];
        };
      }
      # ships inside the 1Password desktop app (cask), so macOS only
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        "1password".command = "/Applications/1Password.app/Contents/MacOS/1password-mcp";
      }
      # remote OAuth servers, enabled per host with ai.mcp.remote
      // lib.optionalAttrs config.ai.mcp.remote {
        cloudflare.url = "https://mcp.cloudflare.com/mcp";
        openrouter.url = "https://mcp.openrouter.ai/mcp";
      };
    };

    _module.args.ai = {
      skills = bundle "ai-skills" ../ai/skills;
      agents = bundle "ai-agents" ../ai/agents;
      plugins = bundle "ai-plugins" ../ai/plugins;
      rules = ../ai/AGENTS.md;
    };
  };
}
