{ ... }:
{
  programs.ghostty = {
    enable = true;

    package = null; # Use the Cask version for now

    settings = {
      theme = "light:Catppuccin Latte,dark:Catppuccin Mocha";
      font-family = "Hack Nerd Font";
      macos-option-as-alt = true;
      macos-titlebar-style = "native";
      confirm-close-surface = false;
      mouse-hide-while-typing = true;
      cursor-color = "cell-foreground";
    };
  };
}
