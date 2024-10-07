#!/bin/sh

printf "BLOCK_DEVICE: "
read BLOCK_DEVICE

# Partition.
parted /dev/${BLOCK_DEVICE} -- mklabel gpt
parted /dev/${BLOCK_DEVICE} -- mkpart primary 512MB -8GB
parted /dev/${BLOCK_DEVICE} -- mkpart primary linux-swap -8GB 100%
parted /dev/${BLOCK_DEVICE} -- mkpart ESP fat32 1MB 512MB
parted /dev/${BLOCK_DEVICE} -- set 3 esp on
sleep 1

# For vda & sda it's vda1 & sda1 etc.
# For nvme, it's nvme0n1p1, nvme0n1p2 etc.
if [[ $BLOCK_DEVICE == nvme* ]]; then
	BLOCK_DEVICE="${BLOCK_DEVICE}p"
fi

# Format.
mkfs.ext4 -L nixos /dev/${BLOCK_DEVICE}1
mkswap -L swap /dev/${BLOCK_DEVICE}2
mkfs.fat -F 32 -n boot /dev/${BLOCK_DEVICE}3
sleep 1

# Mount.
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
