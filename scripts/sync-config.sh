#!/bin/sh

# If any command fails, fail the script.
set -e

# This script assumes that the machine of target address is at an already configured state
# with ssh, rsync, and public key all installed.

TARGET_PORT=22

if [ $# -gt 0 ]; then
	USERNAME="$1"
	TARGET_ADDRESS="$2"
else
	printf "USERNAME: "
	read USERNAME

	printf "TARGET_ADDRESS: "
	read TARGET_ADDRESS

	echo "TARGET_PORT: $TARGET_PORT"
fi

SSH_OPTIONS="\
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -o LogLevel=ERROR"
FLAKE_DIR=$(dirname "$(dirname "$0")")
CONFIG_DIR=/home/$USERNAME/config

# Copy this flake into $CONFIG_DIR.
rsync -av -e "ssh $SSH_OPTIONS -p$TARGET_PORT" \
	--quiet \
	--rsync-path="sudo rsync" \
	$FLAKE_DIR/ $USERNAME@$TARGET_ADDRESS:$CONFIG_DIR
