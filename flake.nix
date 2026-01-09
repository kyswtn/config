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
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
    let
      forAllSystems = fn:
        assert nixpkgs.lib.genAttrs [ "a" "b" ] (x: x + "1") == { a = "a1"; b = "b1"; };
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: fn (system));

      apps = forAllSystems (system: {
        darwin-rebuild = {
          type = "app";
          program = "${nix-darwin.packages.${system}.default}/bin/darwin-rebuild";
        };
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.default}/bin/home-manager";
        };
      });

      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          language-support = pkgs.callPackage ./packages/language-support.nix { };
        });

      mkSystems = import ./lib/mkSystems.nix inputs;
      systems = mkSystems {
        hosts = {
          macbook-pro = {
            localHostName = "Kyaws-MacBook-Pro";
            system = "aarch64-darwin";
            managedBy = "nix-darwin";
            users = [ "kyaw" ];
          };
          macbook-air = {
            system = "aarch64-linux";
            managedBy = "nixos";
            users = [ "kyaw" ];
          };
          beelink = {
            system = "x86_64-linux";
            managedBy = "nixos";
            users = [ "kyaw" ];
          };
          utm = {
            system = "aarch64-linux";
            managedBy = "nixos";
            users = [ "kyaw" ];
          };
        };
      };
    in
    systems // { inherit apps packages; };
}
