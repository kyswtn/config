#!/bin/sh

commands_exist() {
	for cmd in $1; do
		command -v "$cmd" >/dev/null 2>&1 || return 1
	done
	return 0
}

if ! commands_exist "nix-env"; then
	echo "nix-env not found!"
	exit 1
fi

if commands_exist "git rsync"; then
	exit 0
fi

# All of the above are checks to avoid re-running this command unless necessary.
nix-env -iA nixos.gitMinimal nixos.rsync
