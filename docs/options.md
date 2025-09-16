# CachyOS Tweaks Options

This document lists all available options for the CachyOS performance tweaks NixOS module.

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

These options control specific aspects of the system performance. They can be enabled individually or all at once using the `cachy.all` option.

### `cachy.zram`
- **Type**: Boolean
- **Default**: `true`
- **Description**: Enable or disable ZRAM. When enabled, it provides compressed swap space in RAM which can improve system responsiveness, especially on systems with limited RAM.

### `cachy.kernelTweaks`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable kernel tweaks for performance, including:
  - VM settings (swappiness, cache pressure, dirty pages)
  - Kernel watchdog settings
  - Network stack optimizations

### `cachy.udevRules`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable udev rules for performance, including:
  - Audio device permissions
  - SATA link power management
  - Storage device scheduler settings (BFQ for HDDs, mq-deadline for SSDs, none for NVMe)
  - HDD power management
  - NVIDIA GPU power management
  - CPU DMA latency permissions
  - Dynamic sound card power saving

### `cachy.modprobeConfig`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable modprobe configuration tweaks, including:
  - NVIDIA driver optimizations
  - AMDGPU support for older GCN architectures
  - Blacklisted watchdog modules
  - Sound card power saving disabled

### `cachy.systemdTweaks`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable systemd tweaks, including:
  - Reduced startup and shutdown timeouts

### `cachy.journaldTweaks`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable journald tweaks, including:
  - Reduced system log storage limit

### `cachy.xserverTweaks`
- **Type**: Boolean
- **Default**: `false`
- **Description**: Enable X server tweaks, including:
  - Touchpad tapping enabled by default

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
    kernelTweaks = true;
    udevRules = true;
  };
}
```

### Enable all tweaks but disable specific ones:
```nix
{
  cachy = {
    enable = true;
    all = true;
    xserverTweaks = false;
  };
}
```
