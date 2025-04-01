{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./user-management.nix
  ];

  # Add proper NIX_PATH variables.
  programs.zsh.enable = true;
  programs.fish.enable = true;

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
  networking.firewall = {
    allowedTCPPorts = [
      config.services.kubernetes.apiserver.securePort
    ];
    allowedUDPPorts = [ ];
  };

  # Install git required for flakes.
  # Once booted & home-manager is run, system git is discarded.
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  # Patch dynamic-linking to make vscode-server work.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # These are utilities i wish every OS comes with, therefore installed here and
    # not at home-manager level.
    xclip
    killall
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}

