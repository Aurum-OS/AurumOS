# AurumOS

An operating system made specifically for gaming and emulation.

A release for the Nintendo Wii coming soon (we are not kidding).

Built off of [ezarcher](https://sourceforge.net/projects/ezarch/), [Nyarch KDE](https://github.com/TotallyDIO/NyarchKDE) & [Archii](https://web.archive.org/web/20120510201057/https://wiki.archlinux.org/index.php/Wii_Tutorial).

Using Nyarch stuff because:
1. One of the devs for Aurum is also a dev for Nyarch.
2. They have stuff we can use.

---

## Features

- **Gaming-focused Arch Linux ISO** — ships with Steam, Lutris, RetroArch, Vulkan stack, Mesa drivers, and Pipewire audio.
- **Dual boot support** — BIOS (syslinux) and UEFI (systemd-boot / GRUB).
- **KDE Plasma desktop** — polished gaming-optimized desktop environment.
- **Calamares graphical installer** — custom branding and QML slideshow.
- **Custom TUI installers** — `ezarch.bios` and `ezarch.uefi` for manual partitioning and software selection.
- **Post-install maintenance** — `ezmaint` TUI for updates, key resets, mirrorlist regeneration, and more.
- **Multi-repository support** — Arch Linux, Nyarch (gaming packages), Chaotic-AUR.
- **Nintendo Wii target** — PowerPC build that boots Linux on Wii hardware.

---

## Project Structure

```
├── ezarcher/                  # Desktop edition — Arch Linux live ISO build profile
│   ├── efiboot/               # UEFI boot configuration (systemd-boot)
│   ├── etc/                   # System configuration overlays for the live ISO
│   │   ├── calamares/         # Calamares installer configuration and branding
│   │   ├── default/grub       # GRUB defaults
│   │   ├── systemd/system/    # Custom systemd service units
│   │   └── xdg/               # Autostart and reflector configuration
│   ├── grub/                  # GRUB boot config for ISO
│   ├── mirrorlists/           # Mirror sources for Arch, Nyarch, and Chaotic-AUR
│   ├── syslinux/              # BIOS syslinux boot config
│   ├── usr/                   # Files overlaid into the live ISO
│   │   ├── local/bin/         # Installer and maintenance scripts
│   │   └── share/             # Backgrounds, icons, PKGBUILDs, docs
│   ├── packages.x86_64        # Full package manifest (~500 packages)
│   ├── pacman.conf            # pacman config with all repositories
│   ├── profiledef.sh          # ISO build profile definition
│   └── steps.sh               # Master ISO build script
├── wiiEmulator/               # Wii edition — PowerPC target build
│   ├── pacman.conf            # PowerPC pacman config (archlinuxppc repos)
│   ├── test.sh                # USB detection, partitioning, base install
│   ├── testRevision.sh        # Revised version with KDE Plasma install
│   └── testtesting.sh         # Simple test script
├── LICENSE                    # GNU General Public License v3.0
└── README.md                  # This file
```

---

## Desktop Edition (ezarcher/)

### Prerequisites

- Arch Linux host system
- `archiso` and `mkinitcpio-archiso` packages
- Root privileges

### Building the ISO

```bash
cd ezarcher
sudo bash steps.sh
```

The `steps.sh` script automates:
1. Installing dependencies.
2. Cleaning old build artifacts.
3. Copying the Arch releng profile.
4. Adding systemd service links (NetworkManager, cups, haveged, SDDM).
5. Removing unwanted services.
6. Copying custom configuration files.
7. Setting hostname, users, and passwords.
8. Running `mkarchiso` to produce the final ISO.

The output ISO will be in `ezarcher/out/`.

### Clean Build Artifacts

```bash
rm -rf ezarcher/work ezarcher/out ezarcher/ezreleng
```

### Installing

Boot the generated ISO. On the live desktop, the Calamares installer launches automatically. Alternatively, use the manual TUI installers:

- **BIOS:** `sudo ezarch.bios`
- **UEFI:** `sudo ezarch.uefi`

### Post-Install Maintenance

```bash
sudo ezmaint
```

A terminal user interface for:
- System updates
- Keyring resets
- Mirrorlist regeneration
- Cache cleaning
- Enabling Bluetooth and firewalld

### Default Credentials

| User | Password |
|------|----------|
| `live` (live session) | `live` |
| `root` | `toor` |

---

## Wii Edition (wiiEmulator/)

Targets PowerPC architecture for the Nintendo Wii console.

### Repositories

The historical `archlinuxppc.org` repos are defunct. The Wii edition now uses:
- **ArchPOWER** (`https://repo.archlinuxpower.org/`) — active Arch Linux port to PowerPC (base + extra)
- **Wii Linux extra packages** (`https://repo.wii-linux.org/arch/extra/powerpc/`) — gaming/emulation-focused packages for Wii Linux

### Building

```bash
cd wiiEmulator
sudo bash test.sh           # Base installation
sudo bash testRevision.sh   # With KDE Plasma
```

The scripts handle:
- USB storage device detection
- Partitioning (FAT16 boot, ext2 root, swap)
- Base package installation via `archlinuxppc` repositories
- fstab, hostname, and network configuration

---

## Technical Details

| Attribute | Value |
|-----------|-------|
| Architecture (Desktop) | x86_64 |
| Architecture (Wii) | PowerPC (ppc) |
| Initramfs hooks | base, udev, autodetect, microcode, modconf, kms, keyboard, keymap, consolefont, block, resume, filesystems, fsck |
| Filesystem compression | SquashFS with zstd (`-comp zstd -b 1M`) |
| Kernel cmdline (UEFI) | `cow_spacesize=4G`, `copytoram=n`, modeset options |
| Default locale | `C.UTF-8` |
| Display manager | SDDM |
| Audio | Pipewire |
| Boot modes | `bios.syslinux` and `uefi.grub` |

---

## License

This project is licensed under the GNU General Public License v3.0 — see the [LICENSE](LICENSE) file for details.
