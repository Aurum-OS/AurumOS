# PowerPC Repositories for AurumOS Wii

## Overview

The Wii edition of AurumOS targets PowerPC (32-bit) architecture for the Nintendo Wii console. Historically it relied on `archlinuxppc.org` repositories, which have been defunct for years.

## Active Repositories

### ArchPOWER
- **URL:** `https://repo.archlinuxpower.org/`
- **Repos:** `base`, `testing`
- **Architectures:** `powerpc`, `powerpc64`, `powerpc64le`, `espresso` (WiiU SMP)
- **ArchPOWER** is an active, community-maintained port of Arch Linux to PowerPC/POWER platforms. It provides base system packages and is regularly updated.
- **Website:** https://archlinuxpower.org/

### Wii Linux Extra Packages
- **URL:** `https://repo.wii-linux.org/arch/extra/powerpc/`
- **Maintainer:** [techflashYT](https://github.com/techflashYT/archpower-extra-pkgs)
- **Target:** 32-bit PowerPC for the [Wii Linux Project](https://github.com/Wii-Linux)
- Contains gaming and emulation-focused packages ported from Arch Linux's `extra` repo, including:
  - `love` (LÖVE game engine), `sfml`, `stella` (Atari 2600 emulator)
  - `dosbox`, `doomretro`, `cuberite`, `classicube`
  - `sway`, `picom`, `dwm`, `st`, `jwm`, `geany`
  - `netsurf-fb` (framebuffer web browser), `feh`, `conky`, `busybox`

## Repository Configuration

The repository configuration in `wiiEmulator/pacman.conf` is set up as follows:

```ini
[core]
Server = https://repo.archlinuxpower.org/$repo/os/powerpc

[extra]
Server = https://repo.archlinuxpower.org/$repo/os/powerpc

[extra-wii]
Server = https://repo.wii-linux.org/arch/extra/powerpc
```

To add the Wii Linux keyring (required for `extra-wii`):

```bash
pacman -U https://repo.wii-linux.org/arch/wiilinux/wii-linux-keyring-1.0-2-any.pkg.tar.zst
```

## Historical Context

The original repository entries pointed to:
- `ftp://archlinuxppc.org/$repo/os/ppc/` — domain is now parked, no longer functional
- `http://bauer.dnsdojo.com/repo/$repo/ppc` — mirror is unreachable
- `http://thestorm.taricorp.net/repo/ppc/$repo` — noted as down in the original config

These have been replaced with the active repositories listed above.

## Packages Used

The installation scripts (`test.sh`, `testRevision.sh`) currently install:
- `base`, `base-devel`, `openfwwf` (base system + Wii firmware)
- `plasma-desktop` (KDE Plasma desktop environment, testRevision.sh only)
