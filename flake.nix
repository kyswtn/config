{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      mkSystems = import ./lib/mkSystems.nix inputs;
      systems = mkSystems {
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

      forAllSystems = fn: nixpkgs.lib.attrsets.genAttrs nixpkgs.lib.systems.flakeExposed (system: fn (system));
      apps = forAllSystems (system: {
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.default}/bin/home-manager";
        };
      });
    in
    systems // { inherit apps; };
}
