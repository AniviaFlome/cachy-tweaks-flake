# CachyOS Tweaks Flake

A Nix flake that provides performance [tweaks](https://wiki.cachyos.org/features/cachyos_settings/) by CachyOS.

## Usage

### Adding to your flake inputs

Add this flake to your system's flake inputs:

```nix
{
  inputs = {
    cachy-tweaks = {
      url = "github:AniviaFlome/cachy-tweaks-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then, in your NixOS configuration module, import and enable the module:

```nix
{ inputs, ... }:

{
  imports = [ inputs.cachy-tweaks.nixosModules.default ];

  cachy = {
    enable = true;
    all = false;
    kernel = true;
    udev = true;
  };
}
```

## Options

The module provides the following options under `cachy.*`:

- `enable`: Enable all CachyOS tweaks
- `all`: Enable all CachyOS tweaks at once
- `ananicy`: Enable ananicy-cpp with CachyOS rules
- `audio`: Enable audio tweaks (realtime limits, rtkit log level)
- `kernel`: Enable kernel tweaks for performance
- `scripts`: Enable CachyOS helper scripts
- `modprobe`: Enable modprobe configuration tweaks
- `systemd`: Enable systemd tweaks 
- `udev`: Enable udev rules for performance
- `wireless`: Enable wireless tweaks (set regulatory domain from timezone)
- `xserver`: Enable X server tweaks

## Not implemented tweaks

See [docs/not-added-tweaks.md](docs/not-added-tweaks.md) for CachyOS tweaks that are intentionally not added to this flake.
