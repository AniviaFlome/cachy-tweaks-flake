{ config, lib, ... }:

with lib;

{
  imports = [
    ./kernel.nix
    ./modprobe.nix
    ./udev.nix
    ./systemd.nix
    ./xserver.nix
    ./zram.nix
    ./scripts.nix
  ];

  options.cachy = {
    enable = mkEnableOption "CachyOS tweaks";

    all = mkOption {
      type = types.bool;
      default = false;
      description = "Enable all CachyOS tweaks";
    };
  };
}
