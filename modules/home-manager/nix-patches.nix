{ config, lib, pkgs, ... }:
with lib;
let
  fishEnabled = config.programs.fish.enable;
in
{
  config = {
    # Link missing fish completions for nix-* commands.
    xdg.configFile."fish/completions/nix.fish" = mkIf fishEnabled {
      source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
    };
  };
}
