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

echo "------------------------------------------------"
echo "Success! You selected: $DEVICE"

# -----------------------------------------------------------------
# YOUR CODE GOES HERE
# The $DEVICE variable is now ready for use in the rest of your script.
# Example: fdisk -l "$DEVICE" or mkfs.vfat "$DEVICE"
# -----------------------------------------------------------------