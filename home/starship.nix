{ ... }:
{
  # REVIEW: do we need any magic for https://github.com/catppuccin/starship ?
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      continuation_prompt = "▶ ";

      memory_usage = {
        disabled = false;
        symbol = "🐏 ";
      };
      shlvl = {
        disabled = false;
        symbol = "↕️ ";
      };
      nix_shell = {
        disabled = false;
        symbol = "❄️ ";
      };
      kubernetes = {
        disabled = false;
        symbol = "☸️ ";
      };
      terraform = {
        disabled = false;
        symbol = "🌋 ";
      };
    };
  };
}
