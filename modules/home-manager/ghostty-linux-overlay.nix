{ system, flakeInputs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      ghostty = flakeInputs.ghostty.packages.${system}.default;
    })
  ];
}
