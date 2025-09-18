{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./base.nix
    ./kernel.nix
    ./modprobe.nix
    ./udev.nix
    ./systemd.nix
    ./xserver.nix
    ./zram.nix
    ./scripts.nix
  ];
}
