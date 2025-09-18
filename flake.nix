{
  description = "CachyOS performance tweaks as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      nixosModules = {
        cachy-tweaks = import ./default.nix;
        default = self.nixosModules.cachy-tweaks;
      };
    };
}
