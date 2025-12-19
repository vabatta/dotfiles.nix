{ lib, ... }:
{
  enable = false;
  setupOpts = {
    display.diff.provider = "mini_diff";
    adapters = lib.generators.mkLuaInline ''
      {
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read 'op://Development/Claude Code OAuth Token/credential' --no-newline",
              },
            })
          end,
        }
      }
    '';
    strategies = {
      chat.adapter = "claude_code";
      # inline.adapter = "";
      # cmd.adapter = "";
      # background.adapter = "";
    };
  };
}
