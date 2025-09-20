{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    package = null; # Use the Cask version for now

    settings = {
      theme = "light:catppuccin-latte,dark:catppuccin-mocha";
      font-family = "FiraCode Nerd Font";
      macos-option-as-alt = true;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;
    };
  };
}
