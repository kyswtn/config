{ pkgs, ... }: {
  # Setup Gnome, pre 25.11.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable autologin.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "account";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Remove Gnome bloats.
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-weather
    gnome-maps
    gnome-contacts
    gnome-music
    gnome-terminal
    gnome-characters
    simple-scan
    cheese
    gedit
    epiphany
    geary
    evince
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  # I expect every OS to come with a browser.
  # Therefore firefox is installed here and not at home-manager level.
  programs.firefox = {
    enable = true;
  };
}
