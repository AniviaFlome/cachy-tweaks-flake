{
  description = "CachyOS performance tweaks as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, }:
    {
      nixosModules = {
        cachy-tweaks = import ./modules/cachy-tweaks.nix;
        default = self.nixosModules.cachy-tweaks;
      };
    };
}
