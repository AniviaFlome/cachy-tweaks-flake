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
  options.cachy.ananicy = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable ananicy-cpp with CachyOS rules";
  };

  config = mkIf (cfg.enable && cfg.ananicy) {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
