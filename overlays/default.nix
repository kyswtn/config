{ system, flakeInputs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      zls = flakeInputs.zigtools-zls.packages.${system}.zls;
    })
  ];
}
