#!/bin/sh

# These installation scripts only work on UNIX based system.
# If any command fails, fail the script.
set -e

# Link ~/config, /etc/nixos, and ~/.config/home-manager to provided path.
SOURCE="$1"
ln -s "$SOURCE" /etc/nixos
ln -s "$SOURCE" ~/config
ln -s "$SOURCE" ~/.config/home-manager
