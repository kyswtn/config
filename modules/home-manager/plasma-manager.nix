{ flakeInputs, ... }: {
  imports = [
    flakeInputs.plasma-manager.homeManagerModules.plasma-manager
  ];
}
