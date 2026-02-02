{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.zram = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable or disable ZRAM";
  };

  config = mkIf (cfg.enable && cfg.zram) {
    zramSwap = {
      enable = true;
      algorithm = "ztsd";
      memoryPercent = 100;
      priority = 100;
    };

    services.udev.extraRules = ''
      # ZRAM Rules
      ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", \
          RUN+="${pkgs.bash}/bin/sh -c 'echo N > /sys/module/zswap/parameters/enabled'"
    '';
  };
}
