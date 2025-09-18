{ config, lib, ... }:

with lib;

{
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