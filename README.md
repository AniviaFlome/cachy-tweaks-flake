# CachyOS Tweaks Flake

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
    cachy-tweaks.url = "github:your-username/cachy-tweaks";
  };
}
```

Then, in your NixOS configuration module, import and enable the module:

```nix
{ config, pkgs, ... }:

{
  imports = [ inputs.cachy-tweaks.nixosModules.default ];

  cachy.enable = true;
  
  # Enable all tweaks at once:
  # cachy.all = true;
  
  # Or customize individual components:
  # cachy.zram = "disable";
  # cachy.kernelTweaks = true;
  # cachy.udevRules = true;
  # etc.
}
```

## Options

The module provides the following options under `cachy.*`:

- `enable`: Enable all CachyOS tweaks (default: false)
- `all`: Enable all CachyOS tweaks at once (default: false)
- `zram`: Enable or disable ZRAM ("enable" or "disable", default: "enable")
- `kernelTweaks`: Enable kernel tweaks for performance (default: false)
- `udevRules`: Enable udev rules for performance (default: false)
- `modprobeConfig`: Enable modprobe configuration tweaks (default: false)
- `systemdTweaks`: Enable systemd tweaks (default: false)
- `journaldTweaks`: Enable journald tweaks (default: false)
- `xserverTweaks`: Enable X server tweaks (default: false)

For detailed information about each option, see [docs/options.md](docs/options.md).

## License

MIT
