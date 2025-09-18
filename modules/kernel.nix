{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.kernel = mkOption {
    type = types.bool;
    default = false;
    description = "Enable kernel tweaks for performance";
  };

  config = mkIf (cfg.enable && cfg.kernel) {
    boot.kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.page-cluster" = 0;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "kernel.nmi_watchdog" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.kptr_restrict" = 2;
      "kernel.kexec_load_disabled" = 1;
      "net.core.netdev_max_backlog" = 4096;
      "fs.file-max" = 2097152;
    };

    boot.kernelParams = [
      "max_ptes_none=409"
    ];
  };
}