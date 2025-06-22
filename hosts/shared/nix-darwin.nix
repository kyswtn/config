{ system, hostName, localHostName, flakeInputs, ... }:
{
  # Configure nix.
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = false;
      trusted-users = [ "root" "kyaw" ];
    };
    extraOptions = ''
      !include /etc/nix/extras.conf
      !include /etc/nix/secret.conf
    '';
    gc = {
      automatic = true;
      interval = { Weekday = 7; Hour = 0; Minute = 0; };
      options = "--delete-older-than 1w";
    };
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # These are defined in flake.nix and are passed down as specialArgs.
  nixpkgs.hostPlatform = system;
  networking.hostName = hostName;
  networking.localHostName = localHostName;

  # Configure timezone.
  time.timeZone = "Asia/Bangkok";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = with flakeInputs; self.rev or self.dirtyRev or null;
}
