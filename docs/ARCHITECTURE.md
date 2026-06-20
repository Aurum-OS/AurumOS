# Architecture Overview

## Desktop Edition Build Pipeline

```
┌──────────────┐     ┌────────────────┐     ┌──────────────┐
│  Arch releng │────▶│  Custom Overlay│────▶│  mkarchiso   │
│  profile     │     │  (config,pkgs) │     │              │
└──────────────┘     └────────────────┘     └──────┬───────┘
                                                   │
                                          ┌────────▼────────┐
                                          │  AurumOS ISO    │
                                          │  (SquashFS)     │
                                          └────────┬────────┘
                                                   │
                                          ┌────────▼────────┐
                                          │  Boot Live ISO  │
                                          │  → Calamares    │
                                          │  → ezarch.bios  │
                                          │  → ezarch.uefi  │
                                          └─────────────────┘
```

### Key Components

**`steps.sh`** — Orchestrator. Copies the archiso releng profile, overlays custom files, configs credentials/services, and invokes `mkarchiso`.

**`profiledef.sh`** — ISO metadata: name, label, publisher, boot modes (`bios.syslinux` + `uefi.grub`), filesystem compression (zstd squashfs).

**`pacman.conf`** — Repository configuration pointing to Arch, Nyarch, and Chaotic-AUR mirrors.

**`packages.x86_64`** — Full package list (~500 packages) installed into the live environment.

**`efiboot/`** — UEFI systemd-boot entries with kernel cmdline options.

**`syslinux/`** — BIOS boot menu configuration.

**`grub/`** — GRUB config for ISO boot fallback.

**`etc/`** — System config overlays (Calamares profile, sudoers, locale, mkinitcpio, SDDM, autostart, etc.).

**`usr/local/bin/`** — Installer scripts (`ezarch.bios`, `ezarch.uefi`) and maintenance tools (`ezmaint`).

**`usr/share/ezarcher/`** — Project resources: docs, install guides, PKGBUILDs, wallpapers.

### Calamares Installer Sequence

```
welcome → locale → keyboard → partition → users → summary
  └──→ partition → mount → unpackfs → machineid → locale → keyboard
      → localecfg → luksbootkeyfile → luksopenswaphookcfg → fstab
      → mvezmkinit (custom) → initcpiocfg → initcpio → removeuser
      → users → networkcfg → displaymanager → packages → hwclock
      → services-systemd → grubcfg → bootloader → ezfinish (custom)
      → umount
  └──→ finished
```

## Wii Edition

```
USB Storage
│
├── Partition 1: FAT16 (256 MB) ── boot
├── Partition 2: ext2  (1600 MB) ── root
└── Partition 3: swap (128 MB)
         │
         ▼
  pacstrap via archlinuxpower.org + wii-linux.org repos
         │
         ▼
  base + base-devel + openfwwf + (optional) plasma-desktop
         │
         ▼
  Write fstab, hostname, hosts → unmount
```

## Repository Layout

```
AurumOS/
├── ezarcher/           # Desktop x86_64 ISO build
│   ├── steps.sh        # Build orchestrator
│   ├── profiledef.sh   # ISO metadata
│   ├── pacman.conf     # Repository config
│   ├── packages.x86_64 # Package manifest
│   ├── efiboot/        # UEFI boot
│   ├── syslinux/       # BIOS boot
│   ├── grub/           # GRUB boot
│   ├── etc/            # System config
│   ├── usr/            # Live filesystem overlay
│   └── mirrorlists/    # Mirror sources
├── wiiEmulator/        # Wii PowerPC build
│   ├── pacman.conf     # PPC repository config
│   ├── test.sh         # Base installer
│   └── testRevision.sh # KDE installer
└── docs/               # Documentation
```
