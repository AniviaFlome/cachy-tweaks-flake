{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.zram = mkOption {
    type = types.bool;
    default = true;
    description = "Enable or disable ZRAM";
  };

  config = mkIf (cfg.enable && cfg.zram) {
    zramSwap = {
      enable = true;
      algorithm = "ztsd";
      memoryPercent = 100;
      priority = 100;
    };
  };
}