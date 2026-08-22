{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.cachy;

  # Lua scripts need a lua interpreter; writeScriptBin would wrap them in bash
  lua = pkgs.lua.withPackages (ps: with ps; [ luv ]);

  mkShellScript = name: pkgs.writeScriptBin name (builtins.readFile ./scripts/${name}.sh);

  topmem = pkgs.writeShellScriptBin "topmem" ''
    exec ${lib.getExe' lua "lua"} ${./scripts/topmem.lua} "$@"
  '';

  scripts = map mkShellScript [
    "cachyos-bugreport"
    "dlss-swapper"
    "dlss-swapper-dll"
    "game-performance"
    "kerver"
    "paste-cachyos"
    "sbctl-batch-sign"
    "zink-run"
  ];

  dependencies = with pkgs; [
    inxi
    power-profiles-daemon
    pciutils
    curl
    sbctl
  ];
in

{
  options.cachy.scripts = mkOption {
    type = types.bool;
    default = cfg.all;
    description = "Enable CachyOS helper scripts";
  };

  config = mkIf (cfg.enable && cfg.scripts) {
    environment.systemPackages = scripts ++ [ topmem ] ++ dependencies;
  };
}
