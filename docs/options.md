## Main Options

### `cachy.enable`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable or disable all CachyOS tweaks. This is the main toggle for the entire module.

### `cachy.all`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable all CachyOS tweaks at once. When set to `true`, this automatically enables all individual tweak options listed below.

## Individual Tweak Options

### `cachy.all`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable all of the tweaks

### `cachy.ananicy`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable ananicy-cpp with CachyOS rules

### `cachy.audio`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable audio tweaks.

### `cachy.kernel`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable kernel tweaks.

### `cachy.modprobe`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable modprobe configuration tweaks.

### `cachy.scripts`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable CachyOS helper scripts.

### `cachy.scripts`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable CachyOS helper scripts. The following scripts will be available in your system:
  - `cachyos-bugreport` - Collects various logs from inxi, dmesg and journalctl to aid in troubleshooting
  - `game-performance` - Wrapper script for powerprofilesctl to switch to performance profile on-demand
  - `dlss-swapper` - Wrapper script to force the latest DLSS preset in games that support the technology
  - `dlss-swapper-dll` - Like dlss-swapper, but requires manually updating the nvngx_dlss.dll library
  - `kerver` - QoL script to show information about the current kernel
  - `paste-cachyos` - Script to paste terminal output for text files from the system
  - `sbctl-batch-sign` - Helper script to easily sign kernel images and EFI binaries for secure boot
  - `topmem` - Shows RAM & swap & ksm stats of 10 processes in a descending order
  - `zink-run` - Makes it easier to execute an OpenGL program through Zink Gallium Driver

### `cachy.systemd`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable systemd tweaks.

### `cachy.wireless`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable wireless tweaks.

### `cachy.xserver`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable X server tweaks.

### `cachy.udev`
- **Type**: Boolean
- **Default**: `config.cachy.all`
- **Description**: Enable udev rules.

## Usage Examples

### Enable all tweaks at once:
```nix
{
  cachy = {
    enable = true;
    all = true;
  };
}
```

### Enable only specific tweaks:
```nix
{
  cachy = {
    enable = true;
    kernel = true;
    udev = true;
  };
}
```

### Enable all tweaks but disable specific ones:
```nix
{
  cachy = {
    enable = true;
    all = true;
    xserver = false;
  };
}
```
