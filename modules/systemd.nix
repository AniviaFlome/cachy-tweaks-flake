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

    # CachyOS usr/lib/systemd/user.conf.d/00-timeout.conf and 10-limits.conf
    systemd.user.settings = {
      Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";
        DefaultLimitNOFILE = "1024:1048576";
      };
    };

    services.journald.extraConfig = ''
      SystemMaxUse=50M
    '';

    # CachyOS usr/lib/tmpfiles.d/coredump.conf
    systemd.tmpfiles.rules = [
      "e /var/lib/systemd/coredump - - - 3d"
    ];

    # CachyOS usr/lib/systemd/system/user@.service.d/delegate.conf
    # Shipped via systemd.packages because NixOS owns /etc/systemd/system wholesale.
    systemd.packages = [
      (pkgs.writeTextDir "lib/systemd/system/user@.service.d/delegate.conf" ''
        [Service]
        Delegate=cpu cpuset io memory pids
      '')
    ];

    # CachyOS usr/lib/systemd/timesyncd.conf.d/10-timesyncd.conf
    # Upstream falls back to the Arch NTP pool; use the NixOS pool instead
    networking.timeServers = [
      "time.cloudflare.com"
      "time.google.com"
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };
}
