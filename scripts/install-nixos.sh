#!/bin/sh

# If any command fails, fail the script.
set -e

printf "HOSTNAME: "
read -r HOSTNAME

printf "USERNAME: "
read -r USERNAME

stty -echo
printf "PASSWORD: "
read -r PASSWORD
stty echo
printf "\n"

# Install NixOS.
FLAKE_DIR=$(realpath "$(dirname "$(dirname "$0")")")
# Mark directory as safe to use for nix.
git config --global --add safe.directory "$FLAKE_DIR"
nixos-install --no-root-passwd --impure --flake "$FLAKE_DIR#$HOSTNAME"

# Important directories.
CFG_DIR_NAME="config"

# Remove existing directories to make the script idempotent.
rm -rf "/mnt/etc/nixos"
rm -rf "/mnt/home/$USERNAME/$CFG_DIR_NAME"

# Make required directories.
mkdir -p "/mnt/etc"
mkdir -p "/mnt/home/$USERNAME/.config"
mkdir -p "/mnt/home/$USERNAME/.local/state/nix/profiles"

# Make a copy for the user to be able to rebuild immediately after logging in.
cp -r "$FLAKE_DIR" "/mnt/home/$USERNAME/$CFG_DIR_NAME"

# Make files made/copied here editable by user.
# Then /etc/nixos from ~/config.
nixos-enter -c "\
  chown -R $USERNAME:users /home/$USERNAME/.config && \
  chown -R $USERNAME:users /home/$USERNAME/.local && \
  chown -R $USERNAME:users /home/$USERNAME/$CFG_DIR_NAME/ && \
  ln -s /home/$USERNAME/$CFG_DIR_NAME/ /etc/nixos
  "

# Set user password.
# This only works if users.mutableUsers is true.
nixos-enter -c "echo '$USERNAME:$PASSWORD' | chpasswd"
