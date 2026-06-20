# Building AurumOS Desktop ISO

## Prerequisites

- Arch Linux host system
- Root privileges (for `archiso` and `pacstrap`)
- At least 10 GB free disk space

## Dependencies

The build script (`steps.sh`) installs these automatically, but you can install them manually:

```bash
sudo pacman -S --needed archiso mkinitcpio-archiso
```

## Build the ISO

```bash
cd ezarcher
sudo bash steps.sh
```

### What steps.sh does

1. **Prepereqs** — Installs `archiso` and `mkinitcpio-archiso` if missing
2. **Cleanup** — Removes old `ezreleng/`, `work/`, and `out/` directories
3. **cpezreleng** — Copies the Arch releng profile as a base
4. **addnmlinks** — Enables systemd services (NetworkManager, cups, haveged)
5. **rmunitsd** — Removes unwanted services (cloud-init, sshd, iwd, hyper-v)
6. **cpmyfiles** — Copies custom config: `pacman.conf`, `profiledef.sh`, `packages.x86_64`, boot configs, `etc/`, `usr/`
7. **sethostname** — Sets hostname to `AurumOS`
8. **crtpasswd/group/shadow/gshadow** — Creates `live` user and root accounts
9. **enablesddmpop** — Enables SDDM display manager
10. **runmkarchiso** — Runs `mkarchiso -A AurumOS -P AurumOS -v -w ./work -o ./out ./ezreleng`

## Output

The finished ISO appears at `ezarcher/out/aurum-YYYYMM-x86_64.iso`.

## Clean Build Artifacts

```bash
rm -rf ezarcher/work ezarcher/out ezarcher/ezreleng
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `mkarchiso` fails with "no space left" | Free up disk space or increase TMPDIR |
| Package download failures | Check `ezarcher/pacman.conf` mirrors and internet connection |
| Script fails halfway | Run `steps.sh` again — it cleans and restarts fresh |
