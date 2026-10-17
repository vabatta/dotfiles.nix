{ ai, ... }:
{
  programs.zed-editor = {
    enable = true;

    enableMcpIntegration = true;

    package = null; # Use the Cask version

    extensions = [ "catppuccin" ];

    userSettings = {
      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      buffer_font_family = "Hack Nerd Font";
      ui_font_family = "Helvetica Neue";
      buffer_font_size = 14;
      ui_font_size = 15;
      option_as_meta = true;

      language_models.open_router.api_url = "https://openrouter.ai/api/v1";

      agent.default_model = {
        provider = "openrouter";
        model = "openrouter/auto";
      };
    };
  };

  home.file.".agents/skills".source = ai.skills;
}
