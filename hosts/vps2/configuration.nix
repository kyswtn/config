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
  services.tailscale.enable = true;
  # This is a placeholder for when I mess up tailscale and need to re-enable temporary
  # SSH back for emergencies.
  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    # These are needed for Neovim and plugins.
    gnumake
    clang
    fd
    ripgrep
    flakeInputs.neovim-nightly-overlay.packages.${system}.tree-sitter
    flakeInputs.neovim-nightly-overlay.packages.${system}.default
    trash-cli
    btop
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
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
