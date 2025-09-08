{
  pkgs,
  lib,
  primaryUser,
  ...
}:
{
  networking.hostName = "mbp";

  # host-specific homebrew casks
  homebrew.casks = [

  ];

  # host-specific home-manager configuration
  home-manager.users.${primaryUser} = {
    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [

    ];

    programs = {
      ssh = {
        enable = true;
        forwardAgent = true;
      };

      zsh = {
        localVariables = {
          SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };

        initContent = lib.mkOrder 1500 ''
          # Source shell functions
          source ${./shell-functions.sh}
        '';
      };

      git.extraConfig.credential = {
        helper = "osxkeychain";
      };
    };
  };
}
