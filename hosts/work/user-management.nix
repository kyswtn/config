{ pkgs, ... }:
let
  credentials = import ../../credentials.nix;
in
{
  users.users.kyaw = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = credentials.sshKeys;
    shell = pkgs.fish;
  };
}
