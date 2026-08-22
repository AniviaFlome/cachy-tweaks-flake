{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.audio = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable audio tweaks (realtime limits, rtkit log level)";
  };

  config = mkIf (cfg.enable && cfg.audio) {
    # CachyOS etc/security/limits.d/20-audio.conf
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@audio";
        type = "-";
        item = "nice";
        value = "-11";
      }
    ];

    # CachyOS usr/lib/systemd/system/rtkit-daemon.service.d/override.conf
    # Expressed via the systemd module so it merges with the drop-in NixOS
    # already generates for rtkit-daemon instead of colliding with it.
    systemd.services.rtkit-daemon.serviceConfig.LogLevelMax = "info";
  };
}
