{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.cachy;

  # CachyOS usr/lib/iw-set-regdomain, adapted for NixOS paths
  iw-set-regdomain = pkgs.writeShellScript "iw-set-regdomain" ''
    # SPDX-License-Identifier: ISC
    # SPDX-FileCopyrightText: 2025 Thomas Duckworth <tduck@filotimoproject.org>
    # SPDX-FileCopyrightText: 2009-2014 Red Hat, Inc.
    # SPDX-FileCopyrightText: 2025 Velocity Limitless, LLC.

    # See https://gitlab.com/VelocityLimitless/Projects/iw-setregdomain

    # Copyright 2009-2014 Red Hat, Inc.  All rights reserved.
    #
    # Permission to use, copy, modify, and/or distribute this software for any
    # purpose with or without fee is hereby granted, provided that the above
    # copyright notice and this permission notice appear in all copies.
    #
    # THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    # WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    # MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    # ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    # WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    # ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    # OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

    REGDOMAIN=/etc/iw-regdomain

    LOGGER="${pkgs.util-linux}/bin/logger -t iw-set-regdomain"

    getcountry() {
      while read c a z r; do
        if [ "$z" = "$ZONE" ]; then
          echo "$c"
          break
        fi
      done < "${pkgs.tzdata}/share/zoneinfo/zone.tab"
    }

    if [ -f "$REGDOMAIN" ]; then
      COUNTRY=$(sed -n 's/^COUNTRY=//p' "$REGDOMAIN" | head -1)
      if [ -n "$COUNTRY" ]; then
        ${pkgs.iw}/bin/iw reg set "$COUNTRY"
        exit
      fi
    fi

    ZONE=$(${pkgs.systemd}/bin/timedatectl show -P Timezone 2>/dev/null)

    if [ -z "$ZONE" ]; then
      $LOGGER -s "Could not determine timezone. Unable to set wireless regulatory domain."
      exit 1
    fi

    COUNTRY=$(getcountry)

    if [ -z "$COUNTRY" ]; then
      case "$ZONE" in
        UTC|UCT|Universal|Zulu|GMT|Etc/UTC|Etc/UCT|Etc/Universal|Etc/Zulu|Etc/GMT)
          $LOGGER "Timezone is $ZONE, with no associated country. Not setting wireless regulatory domain."
          exit 0
          ;;
      esac

      $LOGGER -s "Could not determine country for $ZONE. Unable to set wireless regulatory domain."
      exit 1
    fi

    $LOGGER "Setting regulatory domain to $COUNTRY based on timezone ($ZONE)."
    ${pkgs.iw}/bin/iw reg set "$COUNTRY"
  '';
in

{
  options.cachy.wireless = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable wireless tweaks (set regulatory domain from timezone)";
  };

  config = mkIf (cfg.enable && cfg.wireless) {
    # CachyOS usr/lib/udev/rules.d/85-iw-regulatory.rules
    # SPDX-License-Identifier: ISC
    # SPDX-FileCopyrightText: 2025 Thomas Duckworth <tduck@filotimoproject.org>
    # SPDX-FileCopyrightText: 2009-2014 Red Hat, Inc.
    # SPDX-FileCopyrightText: 2025 Velocity Limitless, LLC.
    services.udev.extraRules = ''
      # Set wireless regulatory domain at device creation
      SUBSYSTEM=="ieee80211", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="cachyos-iw-set-regdomain.service"
    '';

    # CachyOS usr/lib/systemd/system/cachyos-iw-set-regdomain.service
    systemd.services.cachyos-iw-set-regdomain = {
      description = "Set Wireless Regulatory Domain on Timezone Change";
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${iw-set-regdomain}";
      };
    };

    # CachyOS usr/lib/systemd/system/cachyos-iw-set-regdomain.path
    systemd.paths.cachyos-iw-set-regdomain = {
      description = "Monitor Timezone Changes to Set Wireless Regulatory Domain";
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = "/etc/localtime";
        Unit = "cachyos-iw-set-regdomain.service";
      };
    };
  };
}
