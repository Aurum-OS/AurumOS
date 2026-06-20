# Wii Edition Installation Guide

AurumOS Wii targets PowerPC (32-bit) architecture for the Nintendo Wii console.

## Prerequisites

- Nintendo Wii console with Homebrew Channel
- USB storage device (at least 2 GB recommended)
- Linux host system for preparing the USB drive
- ArchPOWER keyring installed (see [PPC-REPOS.md](PPC-REPOS.md))

## Scripts

There are three scripts in `wiiEmulator/`:

| Script | Description |
|--------|-------------|
| `test.sh` | Original installer — partitions USB, installs base system + `openfwwf` firmware |
| `testRevision.sh` | Revised version with functions — same partitions + `plasma-desktop` KDE install |
| `testtesting.sh` | Minimal test script |

## Installation Flow (`testRevision.sh`)

1. **testroot** — Verifies root privileges
2. **findusbs** — Scans for USB storage devices and prompts selection
3. **partitionusb** — Partitions the USB:
   - Partition 1: FAT16, 256 MB (boot)
   - Partition 2: ext2, 1600 MB (root)
   - Partition 3: swap, 128 MB
4. **mountusb** — Mounts partitions to `./mount/boot` and `./mount/aurumos`
5. **installbase** — Installs packages via `pacman` using `wiiEmulator/pacman.conf`
6. **createfiles** — Generates `fstab`, `rc.conf`, and `hosts`
7. **umntclnup** — Unmounts and copies rootfs

## Running

```bash
cd wiiEmulator
sudo bash test.sh
# or
sudo bash testRevision.sh
```

## Packages Installed

### test.sh
- `base`, `base-devel`, `openfwwf`

### testRevision.sh
- `base`, `base-devel`, `openfwwf`, `plasma-desktop`

## Repository Configuration

The `wiiEmulator/pacman.conf` uses:

- **ArchPOWER** — `https://repo.archlinuxpower.org/` (core + extra)
- **Wii Linux extra** — `https://repo.wii-linux.org/arch/extra/powerpc/` (gaming packages)

See [PPC-REPOS.md](PPC-REPOS.md) for details.
