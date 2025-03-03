{ ... }: {
  # Miscellaneous configurations.
  # By the way ’ here is not ' otherwise nix-darwin errors.
  networking.computerName = "Kyaw’s MacBook Pro";

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
    brews = [ ];
    casks = [
      "appcleaner"
      "raycast"
      "alt-tab"
      "notunes"
      "ghostty"
      "zen-browser"
      "obsidian"
      "visual-studio-code"
      "utm"
      "orbstack"
      "1password"
      "proton-mail"
      "spotify"
      "tailscale"
      "discord"
      "notion"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 5;
}
