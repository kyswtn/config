{ flakeInputs, pkgs, ... }: {
  networking.computerName = "Big-Mac";
  system.primaryUser = "rockman";

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
    wvous-tl-corner = /* Mission Control */ 2;
    # Turn off auto rearrangement of spaces.
    mru-spaces = false;
  };

  # Finder.
  system.defaults.finder = {
    ShowPathbar = true;
  };

  environment.systemPackages = with pkgs; [
    gnumake
    clang
    fd
    ripgrep
    fzf
    flakeInputs.neovim-nightly-overlay.packages.${system}.default
    flakeInputs.neovim-nightly-overlay.packages.${system}.tree-sitter

    darwin.trash
    appcleaner
    alt-tab-macos
  ];

  environment.variables.EDITOR = "nvim";
  programs.zsh.enableFzfCompletion = true;
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # Homebrew.
  homebrew = {
    enable = true;
    brews = [
      "zeroclaw"
    ];
    casks = [
      "1password"
      "brave-browser"
      "discord"
      "ghostty"
      "iina"
      "mullvad-vpn"
      "obs"
      "obsidian"
      "proton-mail"
      "raycast"
      "selfcontrol"
      "signal"
      "slack"
      "spotify"
      "tailscale-app"
      "visual-studio-code"
      "zed"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = 5;
}
