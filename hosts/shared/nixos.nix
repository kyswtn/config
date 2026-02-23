{ system, hostName, ... }: {
  # Configure nix.
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

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # These are defined in flake.nix and are passed down as specialArgs.
  nixpkgs.hostPlatform = system;
  networking.hostName = hostName;

  # Configure timezone & locale.
  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";
}
