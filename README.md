## Setup - macOS

```sh
cd ~
scutil --set LocalHostName "Kyaws-MacBook-Pro"

# Clone the directory. Must always be at `~/config` as some scripts make such an assumption.
git clone https://github.com/kyswtn/config.git ~/config

# Install homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Setup nix-darwin.
nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  run nix-darwin/master#darwin-rebuild -- switch --flake .

# Setup home-manager.
nix run home-manager/master -- switch --flake .

# Make links so that --flake is not required.
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
./scripts/sync-config.sh $USER <IP>
```

## Documentation

- Multiple host configurations are possible.
- Each host can have multiple different users. Users are created at OS level.
- Home manager works on $HOME folders already created.
- Each user can have multiple different features (used by home-manager) which can be turned on/off at flake level.
- Software configurations (e.g. vim, ghostty) live in `/extras`.
