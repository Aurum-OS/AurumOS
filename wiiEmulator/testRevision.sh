#!/bin/bash

# Ver 0.1
# (GNU/General Public License version 3.0)
# by TotallyDIO @ https://github.com/AurumOS
# ----------------------------------------
# Define Variablesa
# ----------------------------------------
rootfs=$(pwd)/mount/aurumos/
bootfs=$(pwd)/mount/boot/

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
# It looks for block devices where TRAN (transport) is usb and TYPE is disk.
mapfile -t USB_DRIVES < <(lsblk -do NAME,SIZE,MODEL,TRAN | awk '$4=="usb" {print "/dev/"$1 " ("$2" - "$3")"}')

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
        # Subtract 1 to match the 0-indexed Bash array
        INDEX=$((CHOICE - 1))
        
        # Extract just the device path (e.g., /dev/sdb) from the array string
        DEVICE=$(echo "${USB_DRIVES[$INDEX]}" | awk '{print $1}')
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
# confirmation
echo "------------------------------------------------"
echo "Success! You selected: $DEVICE"
clear
}

bootfs () {
# starts fdisk to partition the device
echo "starting fdisk utility for $DEVICE..."
(echo o; echo n; echo p; echo 1; echo ""; echo +256M; echo t; echo 6; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkfs.vfat -n boot $DEVICE"1"
sleep 2
}

rootfs () {
(echo n; echo p; echo 2; echo ""; echo +1600M; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkfs.ext2 -L aurum $DEVICE"2"
}

swapfs () {
(echo n; echo p; echo 3; echo ""; echo +128M; echo t; echo 3; echo 82; echo w) | sudo /sbin/fdisk $DEVICE
sudo /sbin/mkswap $DEVICE"3"
}

mountusb () {
# creates mount points & mounts partitoions
sudo mkdir -p  ./mount/boot
sudo mount $DEVICE"1" ./mount/boot

sudo mkdir -p ./mount/aurumos
sudo mount $DEVICE"2" ./mount/aurumos
}
chroot () {
arch-chroot ./mount /bin/bash
}
installbase () {
mkdir -p $(pwd)/var/lib/pacman

#installs base packages
pacman --root $rootfs --cachedir $(rootfs)var/cache/pacman/pkg --config $(pwd)/pacman.conf -b $(rootfs)var/lib/pacman -Sy
pacman --root $rootfs --cachedir $(rootfs)var/cache/pacman/pkg --config $(pwd)/pacman.conf -b $(rootfs)var/lib/pacman -S base base-devel openfwwf plasma-desktop
sudo cp $(pwd)/pacman.conf $rootfs/etc/pacman.conf
}

createfiles () {
    # create fstab
echo "
$DEVICE"2"          /            ext2      defaults,noatime            0 1
$DEVICE"1"          /boot        vfat      defaults,noatime            0 1

tmpfs                   /var/log     tmpfs     size=16m                    0 0" > $(rootfs)etc/fstab
echo "HOSTNAME=aurumos" > $rootfs/etc/rc.conf
echo "127.0.0.1      archlinux.domain.org   localhost.localdomain      localhost    archlinux" > $(rootfs)etc/hosts
}

umntclnup () {
exit
sudo umount $bootfs
sudo umount $rootfs
cp $rootfs $(pwd)
cp $rootfs $(pwd)
}

testroot
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