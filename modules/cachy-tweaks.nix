{ config, lib, ... }:

with lib;

{
  imports = [
    ./base.nix
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

  config = {
    cachy = {
      kernel = mkIf config.cachy.all (mkDefault true);
      udev = mkIf config.cachy.all (mkDefault true);
      modprobe = mkIf config.cachy.all (mkDefault true);
      systemd = mkIf config.cachy.all (mkDefault true);
      xserver = mkIf config.cachy.all (mkDefault true);
      scripts = mkIf config.cachy.all (mkDefault true);
    };
  };
}
