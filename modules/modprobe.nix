{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.modprobe = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable modprobe configuration tweaks";
  };

  config = mkIf (cfg.enable && cfg.modprobe) {
    boot.extraModprobeConfig = ''
      # NVIDIA driver tweaks (CachyOS usr/lib/modprobe.d/nvidia.conf)
      options nvidia NVreg_InitializeSystemMemoryAllocations=0 \
                    NVreg_DynamicPowerManagement=0x02

      # Force AMDGPU on Southern Islands (GCN 1.0) and Sea Islands (GCN 2.0)
      # CachyOS usr/lib/modprobe.d/amdgpu.conf
      options amdgpu si_support=1 cik_support=1
      options radeon si_support=0 cik_support=0

      # Blacklist watchdog modules
      # CachyOS usr/lib/modprobe.d/blacklist.conf
      blacklist iTCO_wdt
      blacklist sp5100_tco
    '';
  };
}
