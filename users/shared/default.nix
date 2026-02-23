{ username, pkgs, system, lib, ... }:
let
  os = (builtins.elemAt (builtins.split "-" system) 2);
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";

  imports = [ ./essentials.nix ]
    # Imports can't rely on pkgs.stdenv!
    ++ (lib.optional (os == "linux") ./linux.nix);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
