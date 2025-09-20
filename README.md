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
    zram = false;
    kernel = true;
    udev = true;
  };
}
```

## Options

The module provides the following options under `cachy.*`:

- `enable`: Enable all CachyOS tweaks (default: false)
- `all`: Enable all CachyOS tweaks at once (default: false)
- `kernel`: Enable kernel tweaks for performance (default: false)
- `scripts`: Enable CachyOS helper scripts (default: false)
- `modprobe`: Enable modprobe configuration tweaks (default: false)
- `systemd`: Enable systemd tweaks (default: false)
- `udev`: Enable udev rules for performance (default: false)
- `xserver`: Enable X server tweaks (default: false)
- `zram`: Enable Zram (default: false)

For detailed information about each option, see [docs/options.md](docs/options.md).
