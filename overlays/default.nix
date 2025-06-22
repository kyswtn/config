{ flakeInputs, ... }: {
  nixpkgs.overlays = with flakeInputs; [
    rust-overlay.overlays.default
    vscode-extensions.overlays.default
  ];
}
