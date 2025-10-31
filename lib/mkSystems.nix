flakeInputs@{ nixpkgs, nix-darwin, home-manager, ... }:
{ hosts }:
let
  inherit (nixpkgs) lib;
  mkMatch = options: value:
    options.${if options ? ${value} then value else "_"};
  systemPrefix = mkMatch {
    nixos = "nixosConfigurations";
    nix-darwin = "darwinConfigurations";
  };
  systemFn = mkMatch {
    nixos = lib.nixosSystem;
    nix-darwin = nix-darwin.lib.darwinSystem;
  };
  mapHost = hostName: { localHostName ? hostName, system, managed-by, users, ... }:
    let
      specialArgs = { inherit system flakeInputs hostName localHostName; };
      key = if managed-by == "nix-darwin" then localHostName else hostName;
      hostConfig = {
        name = systemPrefix managed-by;
        value.${key} = systemFn managed-by {
          modules = [
            ../modules/${managed-by}
            ../hosts/shared/${managed-by}.nix
            ../hosts/${hostName}/configuration.nix
          ];
          inherit specialArgs;
        };
      };
      userConfig = username: {
        name = "homeConfigurations";
        value."${username}@${hostName}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ../modules/home-manager
            ../users/shared
            ../users/${username}/home.nix
          ];
          extraSpecialArgs = specialArgs // { inherit username; };
        };
      };
    in
    [ hostConfig ] ++ map userConfig users;
  configs = lib.flatten (lib.mapAttrsToList mapHost hosts);
in
lib.mapAttrs (_: lib.foldl' (a: b: a // b.value) { })
  (lib.groupBy (c: c.name) configs)
