{ system, hostName, ... }: {
  # Setup nix.
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # These are defined in flake.nix and are passed down as specialArgs.
  nixpkgs.hostPlatform = system;
  networking.hostName = hostName;

  # Setup timezone & keyboard input.
  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";
}
