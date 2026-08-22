# CachyOS Tweaks Not Added

Tweaks from [CachyOS-Settings](https://github.com/CachyOS/CachyOS-Settings) intentionally not implemented here.

## Host configuration required

- **power-profiles-daemon** — `game-performance` needs ppd; enable `services.power-profiles-daemon.enable = true;`.

## Skipped on purpose

- **pci-latency** — rewrites PCI latency timers via `setpci` every boot; impure and situational.
- **NetworkManager DNS** — configure DNS yourself.
- **debuginfod server URL** — only useful for CachyOS-packaged binaries.
- **GNOME login-screen theming / icons** — not a performance tweak.
- **linux-cachyos kernel** — use [nix-cachyos-kernel](https://github.com/xddxdd/nix-cachyos-kernel) instead.
- **sched-ext** — use `services.scx.enable` instead.
