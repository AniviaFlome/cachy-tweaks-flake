# CachyOS Tweaks Flake

## This is made with AI for test purposes, do not use it!

A Nix flake that provides performance tweaks by CachyOS.

## Features

This flake provides a NixOS module that enables various system optimizations for better performance, including:

- Kernel sysctl tweaks for memory management
- Udev rules for storage and audio devices
- Modprobe configuration for GPU drivers
- Systemd timeout optimizations
- Journald configuration tweaks
- X server input device configuration

## Usage

### Adding to your flake inputs

Add this flake to your system's flake inputs:

```nix
{
  inputs = {
    cachy-tweaks.url = "github:AniviaFlome/cachy-tweaks-flake";
  };
}
```

Then, in your NixOS configuration module, import and enable the module:

```nix
{ config, pkgs, ... }:

{
  imports = [ inputs.cachy-tweaks.nixosModules.default ];

  cachy = {
    enable = true;
    all = false;
    zram = false;
    kernelTweaks = true;
    udevRules = true;
}
```

## Options

The module provides the following options under `cachy.*`:

- `enable`: Enable all CachyOS tweaks (default: false)
- `all`: Enable all CachyOS tweaks at once (default: false)
- `zram`: Enable or disable ZRAM (default: true)
- `kernelTweaks`: Enable kernel tweaks for performance (default: false)
- `udevRules`: Enable udev rules for performance (default: false)
- `modprobeConfig`: Enable modprobe configuration tweaks (default: false)
- `systemdTweaks`: Enable systemd tweaks (default: false)
- `journaldTweaks`: Enable journald tweaks (default: false)
- `xserverTweaks`: Enable X server tweaks (default: false)

For detailed information about each option, see [docs/options.md](docs/options.md).

## License

MIT
