{
  pkgs,
  inputs,
  self,
  hostUsername,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # nix config
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  nixpkgs.config.allowUnfree = true;

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${hostUsername} = {
      imports = [
        inputs.nvf.homeManagerModules.default # neovim
        ../home
      ];
    };
    extraSpecialArgs = {
      inherit inputs self hostUsername;
    };
  };

  # linux-specific settings
  programs.zsh.enable = true;
  users.users.${hostUsername} = {
    isNormalUser = true;
    home = "/home/${hostUsername}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
