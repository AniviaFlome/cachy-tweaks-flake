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
      # NVIDIA driver tweaks
      options nvidia NVreg_UsePageAttributeTable=1
                    NVreg_InitializeSystemMemoryAllocations=0
                    NVreg_DynamicPowerManagement=0x02

      # Force AMDGPU on Southern Islands (GCN 1.0) and Sea Islands (GCN 2.0)
      options amdgpu si_support=1 cik_support=1
      options radeon si_support=0 cik_support=0

      # Blacklist watchdog modules
      blacklist iTCO_wdt
      blacklist iTCO_vendor_support
      blacklist sp5100_tco

      # Disable power save for snd_hda_intel
      options snd_hda_intel power_save=0 power_save_controller=N
    '';
  };
}