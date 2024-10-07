{ config, lib, ... }:
with lib;
let
  cfg = config.homebrew;
in
{
  options.homebrew = {
    enableFishIntegration = mkEnableOption "Homebrew's Fish integration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.fish.shellInit = mkIf cfg.enableFishIntegration ''
      # Setup homebrew PATH & completions.
      eval (/opt/homebrew/bin/brew shellenv)
      if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
      end
      if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
      end
    '';
  };
}
