{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.orbstack;
  orbstackPath = "${config.home.homeDirectory}/.orbstack";
in
{
  options.programs.orbstack = {
    enable = mkEnableOption "orbstack";

    package = mkPackageOption pkgs "orbstack" {
      nullable = true;
      default = null;
      extraDescription = "OrbStack isn't available on Nixpkgs yet.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = optional (cfg.package != null) cfg.package;
    # home.sessionPath = [ "${orbstackPath}/bin" ];
    programs.ssh.includes = [
      "${orbstackPath}/ssh/config"
    ];
  };
}
