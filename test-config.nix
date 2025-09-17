{ config, pkgs, ... }:

{
  imports = [ ./modules/cachy-tweaks.nix ];

  cachy.enable = true;
}