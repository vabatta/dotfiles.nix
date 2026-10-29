{ ... }:
{
  # Placeholder so the flake evaluates. On the box, replace it with:
  #   nixos-generate-config --show-hardware-config > hosts/devbox/hardware-configuration.nix
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
