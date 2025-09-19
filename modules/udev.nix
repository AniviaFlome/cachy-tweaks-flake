{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.udev = mkOption {
    type = types.bool;
    default = false;
    description = "Enable udev rules for performance";
  };

  config = mkIf (cfg.enable && cfg.udev) {
    services.udev.extraRules = ''
      # ZRAM Rules
      ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", \
          RUN+="/bin/sh -c 'echo N > /sys/module/zswap/parameters/enabled'"

      # HPET Permissions
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"

      # SATA Active Link Power Management
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", \
          ATTR{link_power_management_policy}=="*", \
          ATTR{link_power_management_policy}="max_performance"

      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
          ATTR{queue/scheduler}="bfq"

      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
          ATTR{queue/scheduler}="mq-deadline"

      # NVMe SSD
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
          ATTR{queue/scheduler}="none"

      # hdparm Rules
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
          ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"

      # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
      ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
          ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
          TEST=="power/control", ATTR{power/control}="auto"

      # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
      ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
          ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
          TEST=="power/control", ATTR{power/control}="on"

      # CPU DMA Latency
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

      # Disables power saving capabilities for snd-hda-intel when device is not
      # running on battery power. This is needed because it prevents audio cracks on
      # some hardware.
      ACTION=="add", SUBSYSTEM=="sound", KERNEL=="card*", DRIVERS=="snd_hda_intel", TEST!="/run/udev/snd-hda-intel-powersave", \
          RUN+="${pkgs.bash}/bin/bash -c 'touch /run/udev/snd-hda-intel-powersave; \
              [[ $$(cat /sys/class/power_supply/BAT0/status 2>/dev/null) != \"Discharging\" ]] && \
              echo $$(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave && \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", TEST=="/sys/module/snd_hda_intel", \
          RUN+="${pkgs.bash}/bin/bash -c 'echo $$(cat /run/udev/snd-hda-intel-powersave 2>/dev/null || \
              echo 10) > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TEST=="/sys/module/snd_hda_intel", \
          RUN+="${pkgs.bash}/bin/bash -c '[[ $$(cat /sys/module/snd_hda_intel/parameters/power_save) != 0 ]] && \
              echo $$(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave; \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"
    '';

    environment.systemPackages = with pkgs; [
      bash
      hdparm
    ];
  };
}
