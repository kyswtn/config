{ ... }: {
  # Miscellaneous configurations.
  # By the way ’ here is not ' otherwise nix-darwin errors.
  networking.computerName = "Kyaw’s MacBook Pro";

  # Tell nixblds' to use 1Password SSH agent for remote store/builders/substituters.
  nix.envVars.SSH_AUTH_SOCK = "/Users/kyaw/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  # Add proper NIX_PATH variables.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.defaults.NSGlobalDomain = {
    # Fastest key repeat rate + lowest delay until repeat.
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    # When i press character keys, don't show accent options.
    ApplePressAndHoldEnabled = false;
  };

  # Keyboard.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Trackpad.
  system.defaults.trackpad = {
    Clicking = true;
    Dragging = false;
  };

  # Dock.
  system.defaults.dock = {
    orientation = "bottom";
    autohide = true;
    show-recents = false;
    show-process-indicators = true;
    # Magnify 5x default size on hover.
    magnification = true;
    largesize = 80;
    # Setup hot corners.
    wvous-tr-corner = /* Mission Control */ 2;
    wvous-bl-corner = /* Launchpad */ 11;
    # Turn off auto rearrangement of spaces.
    mru-spaces = false;
  };

  # Finder.
  system.defaults.finder = {
    ShowPathbar = true;
  };

  # Homebrew.
  homebrew = {
    enable = true;
    taps = [
      "railwaycat/emacsmacport"
      "kamillobinski/thock"
    ];
    brews = [
      "thock"
    ];
    casks = [
      "appcleaner"
      "raycast"
      "alt-tab"
      "notunes"
      "ghostty"
      "iina"
      "obsidian"
      "visual-studio-code"
      "utm"
      "orbstack"
      "1password"
      "proton-mail"
      "spotify"
      "tailscale"
      "discord"
      "telegram"
      "zoom"
      "signal"
      "brave-browser"
      "emacs-mac"
      "obs"
      "google-chrome"
      "wireshark"
      "mochi"
      "slack"
      "mullvad-vpn"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 5;
}
