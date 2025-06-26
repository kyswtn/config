{ pkgs, ... }: {
  home.packages = with pkgs; [ ];

  fonts.fontconfig.enable = true;

  # services.cliphist = {
  #   enable = true;
  # };

  programs.bemenu = {
    enable = true;
    package = pkgs.bemenu;
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = false;
    package = null;
    extraConfig = ''
      # Without this fix, waybar doesn't work due to GTK.
      include /etc/sway/config.d/*
    '';

    config = {
      startup = [
        # Set wallpaper.
        { command = "sway output HDMI-A-1 bg ${./wallpaper.jpg} fill"; always = true; }
      ];
      modifier = "Mod4";
      terminal = "${pkgs.ghostty}/bin/ghostty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      input = {
        "type:keyboard" = {
          xkb_layout = "us,mm";
          xkb_options = "ctrl:nocaps";
          repeat_delay = "300";
          repeat_rate = "60";
        };
      };
      bars = [ ];
      fonts = {
        names = [ "Input Mono" "FontAwesome" ];
        style = "Regular Regular";
        size = 12.0; # In pt.
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "Input Mono";
    extraConfig = {};
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        position = "top";
        height = 32;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "clock"
          "tray"
        ];
        cpu = {
          format = "{usage}%  CPU";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        tray = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        font-family: "Input Mono", FontAwesome;
        font-size: 16px;
        font-weight: 700;
        color: #ffffff;
      }

      window#waybar {
        background-color: rgba(0, 0, 0, 0.5);
        padding: 5px;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #ffffff;
        border: none;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.9);
      }

      #workspaces button.focused {
        border-bottom: 2px solid #ffffff;
      }

      #cpu,
      #memory,
      #temperature,
      #clock,
      #tray {
        padding: 0 10px;
        color: #ffffff;
      }

      #window,
      #workspaces {
        margin: 0 4px;
      }

      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }
    '';
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
