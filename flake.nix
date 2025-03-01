{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zigtools-zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkSystems = import ./lib/mksystems.nix inputs;
      systems = mkSystems {
        features = [ "language-support" "plasma" ];
        hosts = {
          macbook-pro = {
            localHostName = "Kyaws-MacBook-Pro";

            system = "aarch64-darwin";
            managed-by = "nix-darwin";
            users = [ "kyaw" ];
            selected-features = [ "language-support" ];
          };
          utm-linux = {
            system = "aarch64-linux";
            managed-by = "nixos";
            users = [ "kyaw" ];
            selected-features = [ "language-support" "plasma" ];
          };
        };
      };
    in
    systems // { };
}
