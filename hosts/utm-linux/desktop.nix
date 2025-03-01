# Unused at the moment.

{ pkgs, ... }: {
  # Setup KDE.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
  ];

  # I expect every OS to come with a browser.
  # Therefore firefox is installed here and not at home-manager level.
  programs.firefox = {
    enable = true;
  };
}
