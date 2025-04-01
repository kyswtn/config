{ ... }: {
  imports = [
    ./1password.nix
    ./home-manager-patches.nix
    ./nix-patches.nix
    ./vscode-patches.nix
    ./vscode-extensions-overlay.nix
  ];
}
