#!/bin/sh

# If any command fails, fail the script.
set -e

TARGET_PORT=22

if [ $# -gt 0 ]; then
  USERNAME="$1"
  TARGET_ADDRESS="$2"
else
  printf "USERNAME: "
  read -r USERNAME

  printf "TARGET_ADDRESS: "
  read -r TARGET_ADDRESS

  echo "TARGET_PORT: $TARGET_PORT"
fi

SSH_OPTIONS="\
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -o LogLevel=ERROR"

# Copy this flake into $CONFIG_DIR.
ssh "$SSH_OPTIONS" -p$TARGET_PORT \
  "$USERNAME@$TARGET_ADDRESS"
