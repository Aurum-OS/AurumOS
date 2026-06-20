# Customizing AurumOS

## Adding/Removing Packages

Edit `ezarcher/packages.x86_64` — this is the full package manifest for the ISO. Each line is a package name recognized by `pacman`.

```bash
# Add a package
echo "my-package" >> ezarcher/packages.x86_64

# Remove a package (delete or comment the line)
# sed -i '/unwanted-package/d' ezarcher/packages.x86_64
```

## Changing Default Credentials

Edit the variables at the top of `ezarcher/steps.sh`:

```bash
MYUSERNM="live"        # Live session username
MYUSRPASSWD="live"     # Live session password
RTPASSWD="toor"        # Root password
MYHOSTNM="AurumOS"     # System hostname
```

## Changing the ISO Metadata

Edit `ezarcher/profiledef.sh`:

```bash
iso_name="Aurum"
iso_label="AURUM-OS_$(date +%y%m)"
iso_publisher="Aurum OS <https://github.com/orgs/Aurum-OS>"
iso_application="Aurum OS DVD"
```

## Changing Boot Configuration

### UEFI (systemd-boot)
Files in `ezarcher/efiboot/loader/`:
- `loader.conf` — Bootloader config
- `entries/01-archiso-linux.conf` — Main kernel cmdline (add `copytoram=y`, change `cow_spacesize`, etc.)

### BIOS (syslinux)
Files in `ezarcher/syslinux/`:
- `syslinux.cfg` — Main config
- `archiso_head.cfg` — Header with timeout and default entry

### GRUB (ISO fallback)
- `ezarcher/grub/grub.cfg` — GRUB config for ISO boot
- `ezarcher/grub/loopback.cfg` — Loopback boot entry

## Customizing the Live Desktop Environment

### Change Display Manager
Edit `ezarcher/steps.sh` — look for `enablesddmpop` function. Replace `sddm.service` with your DM (e.g., `lightdm.service`, `gdm.service`).

### Add Autostart Scripts
Place `.desktop` files in `ezarcher/etc/xdg/autostart/` and they will run on live session login.

### Change Background/Wallpaper
Replace files in `ezarcher/usr/share/backgrounds/`.

### Add Custom Icons
Add to `ezarcher/usr/share/icons/`.

## Modifying Pacman Repositories

Edit `ezarcher/pacman.conf` to add/remove repositories or change mirrors. Currently configured with:
- Official Arch Linux
- Nyarch Linux (gaming packages)
- Chaotic-AUR

## Rebuilding After Changes

```bash
cd ezarcher
sudo bash steps.sh
```

The script cleans and rebuilds from scratch every time.
