#!/bin/sh

# These installation scripts only work on UNIX based system.
# If any command fails, fail the script.
set -e

# Make sure all the required dependencies are installed to run this script.
commands_exist() {
	for cmd in $1; do
		command -v "$cmd" >/dev/null 2>&1 || return 1
	done
	return 0
}

if ! commands_exist "ssh sshpass rsync"; then
	echo "some required commands are missing!"
	exit 1
fi

# Enquire credentials.
printf "TARGET_ADDRESS: "
read TARGET_ADDRESS

printf "TARGET_PORT: "
read TARGET_PORT

TARGET_USER=root
echo "TARGET_USER: $TARGET_USER"

stty -echo
printf "ROOT_PASSWORD: "
read ROOT_PASSWORD
stty echo
printf "\n"

# Prepare to ssh.
SSH_OPTIONS="\
  -o PubkeyAuthentication=no \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -o LogLevel=ERROR"

run_with_ssh() {
	sshpass -p $ROOT_PASSWORD \
		ssh -t $SSH_OPTIONS -p$TARGET_PORT $TARGET_USER@$TARGET_ADDRESS "$@"
}

# Important directories.
SCRIPT_DIR=$(dirname "$0")
FLAKE_DIR=$(dirname $SCRIPT_DIR)
SETUP_DIR=/setup

# Prepare the installer environment.
PREPARE_SCRIPT=$(cat "$SCRIPT_DIR/prepare-installer.sh")
run_with_ssh "$PREPARE_SCRIPT"

# Copy this flake into $SETUP_DIR.
rsync -av -e "sshpass -p $ROOT_PASSWORD ssh $SSH_OPTIONS -p$TARGET_PORT" \
	--quiet \
	--rsync-path="sudo rsync" \
	$FLAKE_DIR/ $TARGET_USER@$TARGET_ADDRESS:$SETUP_DIR

# Make scripts executable; they're not marked +x within git to avoid accidentally executing them
# on my main machine. There's a horror story behind this.
run_with_ssh "chmod +x $SETUP_DIR/scripts/*.sh"

while true; do
	echo "\nChoose an option:\n"

	echo "1. Prepare /mnt for NixOS installation"
	echo "2. Install NixOS on machine"
	echo "3. Reboot"
	echo "0. SSH into machine"

	printf "> "
	read CHOICE

	case $CHOICE in
	1)
		run_with_ssh "$SETUP_DIR/scripts/prepare-mnt.sh"
		;;
	2)
		run_with_ssh "$SETUP_DIR/scripts/install-nixos.sh"
		;;
	3)
		run_with_ssh "reboot"
		break
		;;
	0)
		run_with_ssh
		;;
	esac
done
