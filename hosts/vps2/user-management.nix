{ pkgs, ... }:
let
  sshKeys = import ../../ssh-keys.nix;
in
{
  users.users = {
    alesis = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = sshKeys;
      shell = pkgs.fish;
    };
  };
  security.sudo.wheelNeedsPassword = false;
}
