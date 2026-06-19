#!/bin/bash

# Ensure the script is run with sufficient privileges to see block devices
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo to ensure all USB devices are detected."
  exit 1
fi

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

# starts fdisk to partition the device
echo "starting fdisk utility for $DEVICE..."
sudo /sbin/fdisk $DEVICE
sleep 2

# make new dos partition table
echo "o \n"
# starts new partition
echo "n \n"
#primary partition
echo "p \n"
#first partition
echo "1 \n"
echo "\n"
#space allocation
echo "+256M \n"
#option to change fs
echo "t \n"
#changes fs to fat16
echo "6 \n"
#writes changes to disk
echo "w \n" 
#makes first partition fat16 & named "boot"
sudo /sbin/mkfs.vfat -n boot $DEVICE"1"

#makes root fs
sudo /sbin/fdisk $DEVICE
#new partition
echo "n \n"
#primary partition
echo "p \n"
#partition number 2
echo "2 \n"
echo "\n"
#space allocation
echo "+1600M /n"
#writes changes to disk
echo "w \n"
# makes second partition ext2 & named "aurum"
sudo /sbin/mkfs.ext2 -L aurum $DEVICE"2"

sudo /sbin/fdisk $DEVICE
#new partition
echo "n \n"
#primary
echo "p \n"
#3rd
echo "3 \n"
echo "\n"
#size
echo "+128M"
#makes it swap
echo "t \n"
echo "3 \n"
echo "82 \n"
#writes to disk
echo "w \n"

sudo /sbin/mkswap $DEVICE"3"
