{ system, flakeInputs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      # Join nixpkgs' vscode-extensions (200+) with nix-vscode-extensions flake's (40K+).
      vscode-extensions = prev.vscode-extensions // flakeInputs.vscode-extensions.extensions.${system};
    })
  ];
}
