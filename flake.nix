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
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkSystems = import ./lib/mksystems.nix inputs;
      systems = mkSystems {
        features = [ "web" ];
        hosts = {
          macbook-pro = {
            localHostName = "Kyaws-MacBook-Pro";

            system = "aarch64-darwin";
            managed-by = "nix-darwin";
            users = [ "kyaw" ];
          };
          vmware-linux = {
            system = "aarch64-linux";
            managed-by = "nixos";
            users = [ "kyaw" ];
            selected-features = [ ];
          };
        };
      };
    in
    systems // { };
}
