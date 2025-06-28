{ config, lib, pkgs, ... }: {
  fonts.fontconfig.enable = true;

  # services.cliphist = {
  #   enable = true;
  # };

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
        { command = "sway output HDMI-A-1 bg ${../../iss073e0204297.jpg} fill"; always = true; }
      ];
      modifier = "Mod4";
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        {
          # Retain defaults.
          "${modifier}+shift+c" = "reload";
          "${modifier}+shift+q" = "kill";
          "${modifier}+shift+space" = "floating toggle";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+r" = "resize";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          # Workspaces.
          "${modifier}+0" = "workspace number 0";
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 0";
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          # Focus.
          "${modifier}+Up" = "focus up";
          "${modifier}+Down" = "focus down";
          "${modifier}+Left" = "focus left";
          "${modifier}+Right" = "focus right";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          # Programs.
          "${modifier}+space" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        };
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
        names = [ "Monaspace Krypton" "FontAwesome" ];
        style = "Regular Regular";
        size = 12.0; # In pt.
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "Monaspace Krypton 12";
    theme = "gruvbox-dark-hard";
    extraConfig = {
      show-icons = true;
    };
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
        font-family: "Monaspace Krypton", FontAwesome;
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
