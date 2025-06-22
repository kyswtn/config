## Setup - Beelink

```sh
# Clone the directory. Must always be at `~/config` as some scripts make such an assumption.
git clone https://github.com/kyswtn/config.git ~/config

# Rebuild switch.
sudo nixos-rebuild switch --flake ~/config#beelink

# Setup home-manager.
nix run home-manager/master -- switch --flake ~/config -b backup

# Make links so that --flake . is not required afterwards.
sudo ln -s /home/$USER/config /etc/nixos/
sudo ln -s /home/$USER/config /home/$USER/.config/home-manager
```

## Setup - MacBook Pro

```sh
scutil --set LocalHostName "Kyaws-MacBook-Pro"

# Clone the directory. Must always be at `~/config` as some scripts make such an assumption.
git clone https://github.com/kyswtn/config.git ~/config

# Install homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Setup nix-darwin.
sudo su
nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  run nix-darwin/master#darwin-rebuild -- switch --flake ~/config

# Setup home-manager.
nix run home-manager/master -- switch --flake ~/config -b backup

# Make links so that --flake . is not required afterwards.
sudo ln -s /Users/$USER/config /etc/nix-darwin
sudo ln -s /Users/$USER/config /Users/$USER/.config/home-manager
```

## Setup - UTM Linux

```sh
# Create an image with minimal NixOS installer. Boot into it.
sudo su
passwd # Sets a temporary password.
ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' # Remember Machine's IP.

# On host macOS.
./scripts/lets-setup.sh # Then Follows instruction.

# For syncing config later.
./scripts/sync-config.sh $USER "<IP or HostName>"
```

## Broken Shell

Zellij requires confirmation before downloading the plugin so the shell will be/look broken initially. Run this to fix it.

```sh
zellij plugin -- https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```

## Documentation

- Multiple host configurations are possible.
- Each host can have multiple different users. Users are created at OS level.
- Home manager works on $HOME folders already created.
- Each user can have multiple different features (used by home-manager) which can be turned on/off at flake level.
- Software configurations (e.g. vim, ghostty) live in `/extras`.
