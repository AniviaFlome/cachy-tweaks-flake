{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.systemd = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable systemd and journald tweaks";
  };

  config = mkIf (cfg.enable && cfg.systemd) {
    systemd.settings = {
      Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";
        DefaultLimitNOFILE = "2048:2097152";
      };
    };

    services.journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };
}
