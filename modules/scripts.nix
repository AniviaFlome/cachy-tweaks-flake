{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.cachy;
in

{
  options.cachy.scripts = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable CachyOS helper scripts";
  };

  config = mkIf (cfg.enable && cfg.scripts) {
    environment.systemPackages = 
      let
        scriptNames = builtins.attrNames (builtins.readDir ./scripts);
        scripts = map (name: pkgs.writeScriptBin name (builtins.readFile ./scripts/${name})) scriptNames;
        dependencies = with pkgs; [
          inxi
          power-profiles-daemon
          pciutils
          curl
          sbctl
          (lua.withPackages (ps: with ps; [ luv ]))
        ];
      in
      scripts ++ dependencies;
  };
}
