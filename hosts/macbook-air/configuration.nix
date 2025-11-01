{ pkgs, ... }: {
  # See macbook-pro/configuration.nix for more detailed comments.
  networking.computerName = "Kyaw’s MacBook Air";
  system.primaryUser = "kyaw";

  # Add proper NIX_PATH variables.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  system.defaults.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    # When i press character keys, don't show accent options.
    ApplePressAndHoldEnabled = false;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.defaults.trackpad = {
    Clicking = true;
    Dragging = false;
  };
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

  system.defaults.finder = {
    ShowPathbar = true;
  };

  environment.systemPackages = with pkgs; [
    darwin.trash
    appcleaner
    alt-tab-macos
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "brave-browser"
      "raycast"
      "utm"
      "mullvad-vpn"
      "1password"
      "tailscale"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 5;
}
