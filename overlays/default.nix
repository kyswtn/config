{ system, flakeInputs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      zig = flakeInputs.zig-overlay.packages.${system}."0.14.0";
      zls = flakeInputs.zigtools-zls.packages.${system}.zls;
    })
  ];
}
