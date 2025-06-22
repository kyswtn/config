{ system, hostName, config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./user-management.nix
  ];

  # Preinstall shells to configure proper NIX_PATH variables.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable automatic login for the user.
  services.getty.autologinUser = "kyaw";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:swapcaps";
  };

  # Use xkb configurations in TTY as well.
  console.useXkbConfig = true;

  # Install and configure minimal git, home-manager will install full git later.
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  # environment.systemPackages = with pkgs; [ ];

  # Enable Tailscale.
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon when Tailscale is not enough for whatever reason.
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = "yes";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
