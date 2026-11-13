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

  # the database stays at ~/.engram, shared by every worktree of a repo
  engramServer = {
    command = "${engram}/bin/engram";
    args = [ "mcp" "--tools=agent" ];
    env.ENGRAM_NO_UPDATE_CHECK = "1";
  };

  # Engram's Claude Code plugin (session hooks, compaction recovery) carrying the engram server itself,
  # so its tools get the mcp__plugin_engram_engram__ names its hooks match
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
    # the mermaid skill's validator; the other tools the skills assume are listed in ai/skills/AGENTS.md
    home.packages = [ validate-mermaid engram ];
    home.sessionVariables.ENGRAM_NO_UPDATE_CHECK = "1";
    # slim: the plugin's session-start hook skips the protocol text the engram server already sends
    home.file.".engram/protocol-mode.json".text = builtins.toJSON { claude-code = "slim"; };

    # every MCP server is declared here; Claude Code, opencode, and Zed read them through enableMcpIntegration
    programs.mcp = {
      enable = true;
      servers = {
        # NOTE: memories stay in ~/.engram on each machine. Syncing them through the repo (engram sync)
        # is only needed to share them with other machines, and would publish them in a public repo.
        engram = engramServer;

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

    # Claude Code gets every server except engram here; engram comes with its plugin
    programs.claude-code = {
      mcpServers = lib.removeAttrs config.programs.mcp.servers [ "engram" ];
      plugins.engram = engramClaudePlugin;
    };

    _module.args.ai = {
      skills = bundle "ai-skills" ../ai/skills;
      agents = bundle "ai-agents" ../ai/agents;
      # opencode plugins: ours plus Engram's from the same release as the binary
      plugins = pkgs.runCommand "ai-plugins" { } ''
        mkdir -p "$out"
        cp -RL ${../ai/plugins}/. "$out/"
        cp ${engram.source}/plugin/opencode/engram.ts "$out/engram.ts"
      '';
      rules = ../ai/AGENTS.md;
    };
  };
}
