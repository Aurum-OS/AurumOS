# Package Overview

AurumOS ships ~500 packages. Below is the breakdown by category.

## Gaming (Nyarch Repos)

| Package | Purpose |
|---------|---------|
| `steam` | Steam gaming platform |
| `lutris` | Game manager (all stores/emulators) |
| `retroarch` | Multi-system emulator frontend |
| `retro-gtk` | GTK libretro frontend |
| `nekoplay` | Nyarch-specific gaming tool |

## Base System

`base`, `base-devel`, `linux`, `linux-firmware*`, `linux-headers`, `mkinitcpio`, `grub`, `syslinux`, `efibootmgr`, `reflector`

## Desktop (KDE Plasma)

`plasma-desktop`, `kwin`, `dolphin`, `konsole`, `kate`, `gwenview`, `spectacle`, `kinfocenter`, `plasma-systemmonitor`, `plasma-disks`, `plasma-nm`, `plasma-pa`, `plasma-vault`, `kdeconnect`, `discover`, `ark`, `kcalc`, `okular`, `k3b`, `print-manager`, `powerdevil`, `bluedevil`, `breeze-icons`, `oxygen`, `papirus-icon-theme`

## Display Manager

`sddm`, `sddm-kcm`, `polkit-kde-agent`

## Graphics & GPU Drivers

| Category | Packages |
|----------|----------|
| Mesa/Vulkan | `mesa`, `vulkan-{intel,radeon,nouveau,virtio,mesa-layers,icd-loader,tools,headers}` |
| Xorg drivers | `xf86-video-{amdgpu,ati,nouveau,intel,vesa,fbdev,dummy,qxl}` |
| Input drivers | `xf86-input-{libinput,evdev,synaptics,wacom,vmmouse,void}` |
| Wayland | `wayland`, `xorg-xwayland`, `kwayland-integration` |

## Multimedia

`pipewire`, `pipewire-{alsa,audio,jack,pulse,v4l2}`, `wireplumber`, `ffmpeg`, `gstreamer` + plugins, `audacious`, `mpv`, `vlc`, `smplayer`, `sox`

## Networking

`networkmanager`, `network-manager-applet`, `firewalld`, `avahi`, `openssh`, `openvpn`, `iwd`, `bluez`, `wpa_supplicant`, `reflector`

## Printing

`cups`, `cups-{pdf,filters,pk-helper}`, `foomatic-db`, `gutenprint`, `ghostscript`, `simple-scan`, `system-config-printer`

## Compression

`tar`, `zip`, `unzip`, `gzip`, `bzip2`, `xz`, `zstd`, `7zip`, `unrar`, `lz4`, `lzip`, `lzop`, `lrzip`, `lha`, `unace`, `unarj`

## Filesystem Support

`btrfs-progs`, `xfsprogs`, `f2fs-tools`, `exfatprogs`, `ntfs-3g`, `bcachefs-tools`, `jfsutils`, `nilfs-utils`, `udftools`, `cryfs`, `encfs`, `gocryptfs`, `gvfs*`

## System Tools

`htop`, `btop`, `inxi`, `hwinfo`, `gparted`, `gnome-disk-utility`, `timeshift`, `testdisk`, `parted`, `gptfdisk`, `clonezilla`, `ddrescue`, `fsarchiver`, `reflector`, `tlp`, `fwupd`, `flatpak`, `keepassxc`

## Calamares Installer

`calamares`, `ckbcomp`, `mkinitcpio-openswap`, `kpmcore`, `extra-cmake-modules`, `kconfig`, `kcoreaddons`, `ki18n`, `kparts`, `kservice`, `kwidgetsaddons`, `libplasma`, `polkit-qt6`, `pybind11`, `python-{jsonschema,pyaml,unidecode}`, `qt6-*`, `solid`, `yaml-cpp`
