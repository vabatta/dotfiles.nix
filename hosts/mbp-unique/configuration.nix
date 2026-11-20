{
  pkgs,
  lib,
  inputs,
  hostUsername,
  ...
}:
{
  networking.hostName = "mbp-unique";

  homebrew.casks = [
    # devtools
    "devtunnel"
    "docker-desktop"
    "mongodb-compass"
    "openlens"
    "google-chrome"
    "cursor"

    # everyday apps
    "loom"
    "slack"
  ];

  homebrew.masApps = {
    "Tailscale" = 1475387142;
  };

  home-manager.users.${hostUsername} = {
    # 1Password, HomeLab: "github - mbp-unique push" and "github - mbp-unique signing".
    github.keys = {
      enable = true;
      pushPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEK0Uv+U9TekQ+Or6XWvh6YdgdMVyh1lahHyD0ZIAdg+";
      signingPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6ahsYuu+Aj2XRyYqd2yZgCmButYJeK/k7Ka5AEzEmI";
    };

    # retired signing keys, so older commits still verify locally
    git.allowedSigningKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZjJGPFzlFedQFJ2ez8DwQS8SuiNFeXNFUSwtl+w892" # 1Password "SSH Key Github"
    ];

    # replaces the agent's default (Personal and Private vaults), so it lists Employee too
    xdg.configFile."1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "Employee"
      account = "3LI3FEGI2JFDFPO75NUVVF6ED4"

      [[ssh-keys]]
      item = "github - mbp-unique push"
      vault = "HomeLab"
      account = "I5YPL3RIZRF6ZIF6YAV6Q2H4ZU"

      [[ssh-keys]]
      item = "github - mbp-unique signing"
      vault = "HomeLab"
      account = "I5YPL3RIZRF6ZIF6YAV6Q2H4ZU"
    '';

    xdg.enable = true;
    home.preferXdgDirectories = true;

    home.packages = with pkgs; [
      azure-cli
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.coderabbit-cli
    ];

    home.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

    programs.ssh.settings."*".IdentityAgent =
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";

    programs = {
      zsh.initContent = lib.mkOrder 1500 ''
        source ${../../scripts/shell-functions.sh}
      '';

      git = {
        settings.user.name = "vabatta";
        settings.user.email = "2137077+vabatta@users.noreply.github.com";
        settings.credential.helper = "osxkeychain";
      };
    };
  };
}
