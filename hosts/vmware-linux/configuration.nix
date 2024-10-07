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

  # This because in a vmware vm.
  # It has to be headless because one of the drivers doesn't exist for aarch64.
  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };
  security.sudo.wheelNeedsPassword = false;

  # For WiFi.
  networking.networkmanager.enable = true;

  # Setup firewall.
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
    displayManager.gdm.enable = true;
    displayManager.gdm.autoLogin.delay = 86400;
    desktopManager.gnome.enable = true;
  };

  # Remove gnome bloats.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    gnome.gnome-weather
    gnome.gnome-maps
    gnome.gnome-contacts
    gnome.gnome-music
    gnome.gnome-terminal
    gnome.gnome-characters
    gnome.simple-scan
    gnome.cheese
    gnome.epiphany
    gnome.geary
    gnome.evince
    gnome.totem
    gnome.tali
    gnome.iagno
    gnome.hitori
    gnome.atomix
  ]);

  # I expect every OS to come with a browser.
  # Therefore firefox is installed here and not at home-manager level.
  programs.firefox = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    # These are utilities i wish every OS comes with, therefore installed here and
    # not at home-manager level.
    xclip
    killall

    # Clipboard sharing doesn't work without this on vmware.
    gtkmm3

    # Thanks Mitchell for this.
    (writeShellScriptBin "xrandr-auto" ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --auto
    '')
  ];

  # I've configured my primary terminal to use fish shell.
  # I don't replace system shell because I've ran into an almost-impossible-to-recover shell 
  # breakage once.
  programs.fish.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}

