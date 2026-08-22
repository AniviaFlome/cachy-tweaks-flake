# CachyOS Tweaks Flake

A Nix flake that provides performance [tweaks](https://github.com/CachyOS/CachyOS-Settings) by CachyOS.

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

The module provides the following options under `cachy.*` — see [docs/options.md](docs/options.md) for full documentation:

- [`enable`](docs/options.md#cachyenable): Enable all CachyOS tweaks
- [`all`](docs/options.md#cachyall): Enable all CachyOS tweaks at once
- [`ananicy`](docs/options.md#cachyananicy): Enable ananicy-cpp with CachyOS rules
- [`audio`](docs/options.md#cachyaudio): Enable audio tweaks
- [`kernel`](docs/options.md#cachykernel): Enable kernel tweaks for performance
- [`scripts`](docs/options.md#cachyscripts): Enable CachyOS helper scripts
- [`modprobe`](docs/options.md#cachymodprobe): Enable modprobe configuration tweaks
- [`systemd`](docs/options.md#cachysystemd): Enable systemd tweaks 
- [`udev`](docs/options.md#cachyudev): Enable udev rules for performance
- [`wireless`](docs/options.md#cachywireless): Enable wireless tweaks
- [`xserver`](docs/options.md#cachyxserver): Enable X server tweaks

## Not implemented tweaks

See [docs/not-added-tweaks.md](docs/not-added-tweaks.md) for CachyOS tweaks that are intentionally not added to this flake.

## License

GPL-3.0-or-later — see [LICENSE](LICENSE).

The `iw-set-regdomain` script and udev rule in `modules/wireless.nix` are ISC-licensed by their original authors. 
Scripts under `modules/scripts/` are from [CachyOS-Settings](https://github.com/CachyOS/CachyOS-Settings) (GPL-3.0-or-later).
