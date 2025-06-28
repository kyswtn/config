{ pkgs, ... }:
let
  credentials = import ../../credentials.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    # /home/kyaw/work/mixrank/etc/nixos/mixrank-dev-machine.nix
  ];

  # Configure primary user.
  users.users.kyaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = credentials.sshKeys;
    shell = pkgs.fish;
  };
  services.getty.autologinUser = "kyaw";
  security.sudo.wheelNeedsPassword = false;

  # Enable **system-level** fish shell.
  programs.fish = {
    enable = true;
    loginShellInit = ''
      # If the user's not an admin & tty is 1 then start sway.
      if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
        exec sway
      end
    '';
  };

  # Configure networking.
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh = {
    enable = false; # Only enable for the first time before running `tailscale up`.
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = "yes";
    };
  };

  # Configure bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
      };
    };
  };
  services.blueman.enable = true;

  # Configure audio.
  services.pipewire.enable = true;

  # Install and configure minimal git, home-manager will install full git later.
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  environment.systemPackages = with pkgs; [
    trash-cli
    wl-clipboard
    mako
  ];

  # Configure window managers.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
  };

  # Force GTK a dark theme.
  environment.variables.GTK_THEME = "Adwaita:dark";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
