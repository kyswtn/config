## Setup - Beelink

```sh
# Clone the directory. Must always be at `~/config` as some scripts make such an assumption.
git clone https://github.com/kyswtn/config.git ~/config

# Rebuild switch.
sudo nixos-rebuild switch --flake ~/config#beelink

# Setup home-manager.
nix run .#home-manager -- switch --flake ~/config -b backup

# Make links so that --flake . is not required afterwards.
sudo rm -rf /etc/nixos
sudo ln -s /home/$USER/config /etc/nixos/
sudo ln -s /home/$USER/config /home/$USER/.config/home-manager
```

## Setup - MacBooks

```sh
# Pro or Air
# scutil --set LocalHostName "Kyaws-MacBook-Pro"
# scutil --set LocalHostName "Kyaws-MacBook-Air"

# Install Nix.
/bin/bash <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# Install homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone the directory. Must always be at `~/config` as some scripts make such an assumption.
git clone https://github.com/kyswtn/config.git ~/config

# Setup nix-darwin.
sudo su
nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  run .#darwin-rebuild -- switch --flake /Users/kyaw/config
exit # quit su

# Setup home-manager.
nix run .#home-manager -- switch --flake ~/config -b backup

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

## Documentation

- Multiple host configurations are possible.
- Each host can have multiple different users. Users are created at OS level.
- Home manager works on $HOME folders already created.
- Systems and homes are configured minimally with only essential configurations.
- More packages are grouped in `/packages` and can be installed with `nix profile install`.
- Software configurations (e.g. vim, ghostty) live in `/extras`.
