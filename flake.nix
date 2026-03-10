{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
          wallpaper-wallpaper = pkgs.callPackage ./packages/wallpaper-wallpaper.nix { };
          shantell-sans = pkgs.callPackage ./packages/shantell-sans.nix { };
          language-support = pkgs.callPackage ./packages/language-support.nix { };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              hcloud
            ];
          };
        });

      mkSystems = import ./lib/mkSystems.nix inputs;
      systems = mkSystems {
        hosts = {
          macbook-pro = {
            localHostName = "Big-Mac";
            system = "aarch64-darwin";
            managedBy = "nix-darwin";
            users = [ "rockman" ];
          };
          vps2 = {
            system = "x86_64-linux";
            managedBy = "nixos";
            users = [ "alesis" ];
          };
        };
      };
    in
    systems // { inherit apps packages devShells; };
}
