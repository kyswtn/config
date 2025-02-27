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
```

## Documentation

- Multiple host configurations are possible. 
- Each host can have multiple different users. Users are created at OS level. 
- Home manager works on $HOME folders already created.
- Each user can have multiple different features (used by home-manager) which can be turned on/off at flake level.
- Software configurations (e.g. vim, ghostty) live in `/extras`.
