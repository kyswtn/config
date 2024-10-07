{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./user-management.nix
  ];

  # Enable sshd.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # These because i'm in a qemu vm.
  services.spice-vdagentd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # For WiFi.
  networking.networkmanager.enable = true;

  # Setup Firewall.
  networking.firewall = {
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Install git required for flakes.
  # Once booted & home-manager is run, system git is discarded.
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  # Enable xserver.
  services.xserver = {
    enable = true;
    dpi = 254;
    windowManager.i3.enable = true;
    displayManager = {
      lightdm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # These are utilities i wish every OS comes with, therefore installed here and
    # not at home-manager level.
    xclip
    killall
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}

