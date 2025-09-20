{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.xserver = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable X server tweaks";
  };

  config = mkIf (cfg.enable && cfg.xserver) {
    services.xserver.config = ''
      Section "InputClass"
          Identifier "libinput touchpad catchall"
          MatchIsTouchpad "on"
          MatchDevicePath "/dev/input/event*"
          Driver "libinput"
          Option "Tapping" "True"
      EndSection
    '';
  };
}