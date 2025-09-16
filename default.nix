{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in {
  imports = [ ./modules/cachy-tweaks.nix ];
}
