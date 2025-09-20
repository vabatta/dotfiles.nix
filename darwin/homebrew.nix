{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "jordanbaird-ice"
      "keepingyouawake"
      "betterdisplay"

      # everyday apps
      "iina"
      "obsidian"

      # devtools
      "ghostty"
      "visual-studio-code"
      "tableplus"

      # other
      "1password"
    ];
    brews = [
      "mas"
    ];
    taps = [

    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Magnet" = 441258766;
      "Yoink" = 457622435;
      "Xcode" = 497799835;
    };
  };
}
