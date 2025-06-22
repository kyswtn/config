{ flakeInputs, ... }: {
  nixpkgs.overlays = [
    flakeInputs.rust-overlay.overlays.default
  ];
}
