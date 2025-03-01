{ ... }: {
  imports = [
    ./1password.nix
    ./home-manager-patches.nix
    ./nix-patches.nix
    ./orbstack.nix
    ./vscode-patches.nix
    ./vscode-extensions-overlay.nix
    # ./plasma-manager.nix
  ];
}
