{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkSystems = import ./lib/mkSystems.nix inputs;
      systems = mkSystems {
        features = [ ];
        hosts = {
          macbook-pro = {
            localHostName = "Kyaws-MacBook-Pro";

            system = "aarch64-darwin";
            managed-by = "nix-darwin";
            users = [ "kyaw" ];
          };
          beelink = {
            system = "x86_64-linux";
            managed-by = "nixos";
            users = [ "kyaw" ];
          };
          utm = {
            system = "aarch64-linux";
            managed-by = "nixos";
            users = [ "kyaw" ];
          };
        };
      };
    in
    systems // { };
}
