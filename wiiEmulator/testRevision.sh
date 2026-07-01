#!/bin/bash

# Ver 0.1
# (GNU/General Public License version 3.0)
# by TotallyDIO @ https://github.com/AurumOS
# ----------------------------------------
# Define Variablesa
# ----------------------------------------
rootfs=$(pwd)/mount/aurumos/
bootfs=$(pwd)/mount/boot/
MIN_REQ_MB=1984

prereqs () {
    sudo pacman -S --needed --noconfirm dosfstools arch-install-scripts
}

testroot () {
  if [[ "$EUID" = 0 ]]; then
    continue
  else
    echo "Please Run As Root"
    sleep 2
    exit
  fi
}

findusbs () {

echo "Scanning for connected USB storage devices..."
echo "------------------------------------------------"

# Mapfile reads the list of USB devices into an array.
mapfile -t USB_DRIVES < <(lsblk -b -do NAME,SIZE,MODEL,TRAN | awk '$4=="usb" {
    size_mb = $2 / 1048576;
    printf "/dev/%s (%.2f MB - %s)\n", $1, size_mb, $3
}')

# Check if any USB devices were found
if [ ${#USB_DRIVES[@]} -eq 0 ]; then
    echo "No USB storage devices detected."
    exit 1
fi

# Display the detected devices in a numbered list
echo "Detected USB Devices:"
for i in "${!USB_DRIVES[@]}"; do
    echo "[$((i+1))] ${USB_DRIVES[$i]}"
done
echo "------------------------------------------------"

# Prompt the user to make a selection
while true; do
    read -p "Select a device by entering the number (1-${#USB_DRIVES[@]}): " CHOICE
    
    # Check if input is a valid integer and within the array range
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#USB_DRIVES[@]}" ]; then
        INDEX=$((CHOICE - 1))
        DEVICE=$(echo "${USB_DRIVES[$INDEX]}" | awk '{print $1}')
        
        # Extract the size, strip the parenthesis, and round to a whole integer
        RAW_SIZE=$(echo "${USB_DRIVES[$INDEX]}" | awk '{print $2}' | tr -d '(')
        SIZE=$(awk -v size="$RAW_SIZE" 'BEGIN { printf "%.0f", size }')
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

echo "------------------------------------------------"
echo "Evaluating device capacity..."

# Exit if the drive is smaller than the absolute minimum requirement
if [ "$SIZE" -lt "$MIN_REQ_MB" ]; then
    echo "Error: The selected device ($DEVICE) is $SIZE MB."
    echo "This is below the minimum partition requirement of $MIN_REQ_MB MB."
    echo "Installation aborted."
    exit 1
fi

# Calculate proportional sizes based on the 1984MB baseline distribution
# awk is used to multiply the total size by the fraction and output a clean integer (%.0f)
BOOTFS_MB=$(awk -v size="$SIZE" 'BEGIN { printf "%.0f", (size * 256) / 1984 }')
SWAP_MB=$(awk -v size="$SIZE" 'BEGIN { printf "%.0f", (size * 128) / 1984 }')

# Rootfs takes the remainder to ensure everything adds up perfectly
ROOTFS_MB=$((SIZE - BOOTFS_MB - SWAP_MB))

# Confirmation Readout
echo "Success! You selected: $DEVICE"
echo "Device Total Size: $SIZE MB"
echo "------------------------------------------------"
echo "Proportional Partition Breakdown:"
echo "- Bootfs (FAT16): $BOOTFS_MB MB"
echo "- Swap:           $SWAP_MB MB"
echo "- Rootfs (ext2):  $ROOTFS_MB MB"
echo "------------------------------------------------"
}

# cleans up fs
cleanup () {
[[ -d $(bootfs) ]] && umount -f $(bootfs)
[[ -d $(rootfs) ]] && umount -f $(rootfs)
if [[ $(swapon --show) != "" ]]; then
    swapoff $(swapon -a)
fi

rm -rf mount var
}


bootfs () {
# starts fdisk to partition the device
echo "starting fdisk utility for $DEVICE..."
(echo o; echo n; echo p; echo 1; echo ""; echo "+$(BOOTFS_MB)M"; echo t; echo 6; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkfs.vfat -n boot $DEVICE"1"
sleep 2
}

rootfs () {
(echo n; echo p; echo 2; echo ""; echo "+$(ROOTFS_MB)M"; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkfs.ext2 -L aurum $DEVICE"2"
}

swapfs () {
(echo n; echo p; echo 3; echo ""; echo "+$(SWAP_MB)M"; echo t; echo 3; echo 82; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkswap $DEVICE"3"
}

mountusb () {
# creates mount points & mounts partitoions
sudo mkdir -p  $bootfs
sudo mount -f $DEVICE"1"  $bootfs

sudo mkdir -p $rootfs
sudo mount -f $DEVICE"2" $rootfs

swapon $DEVICE"3"

sudo mkdir -p ./mount/proc
echo MOUNTUSB
}
chroot () {
arch-chroot ./mount /bin/bash
echo CHROOT
}
installbase () {
mkdir -p $(pwd)/var/lib/pacman

#installs base packages
pacman --root $rootfs --cachedir $(rootfs)var/cache/pacman/pkg --config $(pwd)/pacman.conf -b $(rootfs)var/lib/pacman -Sy
pacman --root $rootfs --cachedir $(rootfs)var/cache/pacman/pkg --config $(pwd)/pacman.conf -b $(rootfs)var/lib/pacman -S base base-devel openfwwf plasma-desktop
sudo cp $(pwd)/pacman.conf $rootfs/etc/pacman.conf
echo INSTALLBASE
}

# Display line error
handlerror () {
clear
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
}

createfiles () {
    # create fstab
echo "
$DEVICE"2"          /            ext2      defaults,noatime            0 1
$DEVICE"1"          /boot        vfat      defaults,noatime            0 1

tmpfs                   /var/log     tmpfs     size=16m                    0 0" > $(rootfs)etc/fstab
echo "HOSTNAME=aurumos" > $rootfs/etc/rc.conf
echo "127.0.0.1      archlinux.domain.org   localhost.localdomain      localhost    archlinux" > $(rootfs)etc/hosts
echo CREATEFILES WORKS
}

umntclnup () {
exit
sudo umount -f $bootfs
sudo umount -f $rootfs
cp $rootfs $(pwd)
cp $rootfs $(pwd)
}

testroot
handlerror
cleanup
findusbs
prereqs
bootfs
rootfs
swapfs
mountusb
chroot
installbase
createfiles
umntclnup