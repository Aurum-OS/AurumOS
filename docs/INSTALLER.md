# Installing AurumOS

AurumOS ships with two installation methods on the live ISO.

## Method 1: Calamares (Graphical)

The Calamares graphical installer launches automatically on boot via `autostart.sh`.

### Installation Sequence

| Step | Module | Description |
|------|--------|-------------|
| 1 | Welcome | Language and region selection |
| 2 | Locale | System locale settings |
| 3 | Keyboard | Keyboard layout |
| 4 | Partition | Disk partitioning (erase, alongside, or manual) |
| 5 | Users | Create username and passwords |
| 6 | Summary | Review choices before install |
| 7 | *(Installation)* | Partitioning → mount → unpack → configure → bootloader |
| 8 | Finished | Reboot prompt |

### Post-Install Actions

Calamares runs custom shellprocess modules:
- **mvezmkinit** — Configures mkinitcpio with openswap hook
- **ezfinish** — Final setup tasks

## Method 2: TUI Installers (Manual)

For advanced users or BIOS systems.

### UEFI Systems

```bash
sudo ezarch.uefi
```

### BIOS Systems

```bash
sudo ezarch.bios
```

Both scripts provide an interactive TUI that lets you:
- Select the target disk
- Choose partitioning scheme
- Pick a desktop environment (Cinnamon, GNOME, KDE, LXQt, MATE, XFCE)
- Select software categories to install
- Configure bootloader

## Default Credentials

| User | Password |
|------|----------|
| `live` (live session) | `live` |
| `root` | `toor` |
