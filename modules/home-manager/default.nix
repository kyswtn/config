{ ... }: {
  imports = [
    ./ghostty.nix
    ./ghostty-linux-overlay.nix
    ./1password.nix
    ./home-manager-patches.nix
    ./nix-patches.nix
    ./orbstack.nix
    ./vscode-patches.nix
    ./vscode-extensions-overlay.nix
  ];
}
