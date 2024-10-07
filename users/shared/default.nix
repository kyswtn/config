{ username, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  # Nixpkgs configurations.
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Home-manager has to manage itself with flakes setup.
  programs.home-manager.enable = true;

  # Home-manager needs these.
  home.username = username;
  home.homeDirectory =
    if isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
}
