{ pkgs, flakeInputs, ... }:
let
  credentials = import ../../credentials.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    flakeInputs.nixos-apple-silicon.nixosModules.default
  ];

  # Configure primary user.
  users.users.kyaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = credentials.sshKeys;
  };
  services.getty.autologinUser = "kyaw";
  security.sudo.wheelNeedsPassword = false;

  # Configure networking.
  networking = {
    networkmanager.enable = true;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };
  services.tailscale.enable = true;
  services.openssh = {
    enable = false; # Only enable for the first time before running `tailscale up`.
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = "yes";
    };
  };

  # Install and configure minimal git, home-manager will install full git later.
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  environment.systemPackages = with pkgs; [
    trash-cli
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
