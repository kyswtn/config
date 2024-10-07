#!/bin/sh

# If any command fails, fail the script.
set -e

printf "HOSTNAME: "
read HOSTNAME

printf "USERNAME: "
read USERNAME

stty -echo
printf "PASSWORD: "
read PASSWORD
stty echo
printf "\n"

# Install NixOS.
FLAKE_DIR=$(realpath "$(dirname "$(dirname "$0")")")
nixos-install --no-root-passwd --impure --flake $FLAKE_DIR#$HOSTNAME

# Important directories.
CFG_DIR_NAME="config"

# Remove existing directories to make the script idempotent.
rm -rf /mnt/etc/nixos
rm -rf /mnt/home/$USERNAME/$CFG_DIR_NAME
rm -rf /mnt/home/$USERNAME/.config/home-manager

# Make required directories.
mkdir -p /mnt/etc
mkdir -p /mnt/home/$USERNAME/.config
mkdir -p /mnt/home/$USERNAME/.local/state/nix/profiles

# Make a copy for the user to be able to rebuild immediately after logging in.
cp -r $FLAKE_DIR /mnt/home/$USERNAME/$CFG_DIR_NAME

# Make files made/copied here editable by user.
# Then link .config/home-manager & /etc/nixos from ~/config.
nixos-enter -c "\
  chown -R $USERNAME:users /home/$USERNAME/$CFG_DIR_NAME/ && \
  chown -R $USERNAME:users /home/$USERNAME/.config && \
  chown -R $USERNAME:users /home/$USERNAME/.local && \
  ln -s /home/$USERNAME/$CFG_DIR_NAME/ /etc/nixos && \
  ln -s /home/$USERNAME/$CFG_DIR_NAME/ /home/$USERNAME/.config/home-manager \
  "

# Set user password.
# This only works if users.mutableUsers is true.
nixos-enter -c "echo '$USERNAME:$PASSWORD' | chpasswd"
