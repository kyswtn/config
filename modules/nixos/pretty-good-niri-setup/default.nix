{ config, lib, pkgs, ... }:
let cfg = config.modules.pretty-good-niri-setup;
in {
  options.modules.pretty-good-niri-setup = with lib; {
    enable = lib.mkEnableOption "Enable Niri set up with pretty good defaults";
  };
  config = lib.mkIf cfg.enable {
    programs.regreet = {
      enable = true;
      package = pkgs.regreet;
    };
    security.pam.services.regreet.enableGnomeKeyring = true; 
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
    environment.etc."niri/config.kdl" = {
      enable = true;
      source = ./config.kdl;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
    };
    environment.etc."xdg/waybar" = {
      enable = true;
      source = ./waybar;
    };
    environment.systemPackages = with pkgs; [
      # Required by Niri.
      xwayland-satellite
      mako
      wl-clipboard
      swaybg
      fuzzel
    ];
  };
}

