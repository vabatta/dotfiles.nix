{ self, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # raise global launchd file-descriptor limit (default 256) so launchd-spawned
  # daemons — notably nix-daemon — can honor their own higher SoftResourceLimits.
  # without this, large parallel fetches/builds hit EMFILE ("Too many open files").
  launchd.daemons.limit-maxfiles = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = [ "launchctl" "limit" "maxfiles" "245760" "491520" ];
      RunAtLoad = true;
      ServiceIPC = false;
    };
  };

  # system defaults and preferences
  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;

    startup.chime = false;

    defaults = {
      dock = {
        magnification = true;
      };

      trackpad = {
        Clicking = false;
        TrackpadThreeFingerDrag = true;
        TrackpadRightClick = true;
      };

      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      finder = {
        AppleShowAllFiles = true; # hidden files
        AppleShowAllExtensions = true; # file extensions
        _FXShowPosixPathInTitle = true; # title bar full path
        ShowPathbar = true; # breadcrumb nav at bottom
        ShowStatusBar = true; # file count & disk space
        FXPreferredViewStyle = "Nlsv"; # listview by default
      };

      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        # Expand save dialog by default
        NSNavPanelExpandedStateForSaveMode = true;
        # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
        AppleKeyboardUIMode = 3;
        # Disable press-and-hold for keys in favor of key repeat
        ApplePressAndHoldEnabled = false;
        # Set a blazingly fast keyboard repeat rate
        KeyRepeat = 1;
        # Set a shorter Delay until key repeat
        InitialKeyRepeat = 15;
      };

      CustomSystemPreferences = {
        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        };

        "com.apple.Mail" = {
          DisableInlineAttachmentViewing = true;
        };
      };
    };
  };
}
