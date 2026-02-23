{ flakeInputs, system, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./user-management.nix
  ]
  ++ (lib.optional (!lib.inPureEvalMode) /impurities.nix);
  # ^ This essentially turns --impure into a binary flag to enable certain features.

  # Fish is only ran by the terminal emulator. I don't chsh it as the default shell.
  # Enabling here is only so that nix completions are loaded.
  programs.fish.enable = true;
  programs.git = {
    enable = true;
    # Only minimal git is installed at system-level.
    # Home-manager will install and configure the complete one.
    package = pkgs.gitMinimal;
  };

  networking.networkmanager.enable = true;
  # Enable localsend's port.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
  services.tailscale.enable = true;
  # This is a placeholder for when I mess up tailscale and need to re-enable temporary
  # SSH back for emergencies.
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Without this, MX Master 3S Mac Mouse doesn't work.
        ControllerMode = "dual";
      };
    };
  };
  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable gnome-keyring as secret service provider and load it up upon first login.
  # But disable GCR SSH agent that it enables, since we use 1Password SSH agent.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # Enable Niri Wayland Compositor (opinionated custom module, comes with goodies configured).
  modules.pretty-good-niri-setup.enable = true;

  environment.systemPackages = with pkgs; [
    # These are needed for Neovim and plugins.
    gnumake
    clang
    fd
    ripgrep
    flakeInputs.neovim-nightly-overlay.packages.${system}.tree-sitter
    flakeInputs.neovim-nightly-overlay.packages.${system}.default

    # These are essentials for every OSs.
    trash-cli
    pavucontrol
    mpv
    ghostty
    brave
    localsend
    btop

    # These are for audio engineering.
    bitwig-studio
    qpwgraph

    # Our custom wallpaper setter script.
    flakeInputs.self.packages.${system}.wallpaper-wallpaper
  ];

  # Terminal essentials.
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };
  # File manager
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [ ];
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
