flakeInputs@{ nixpkgs, nix-darwin, home-manager, ... }:
{ hosts }:
let
  lib = { inherit (nixpkgs.lib) map mapAttrs foldl' groupBy flatten mapAttrsToList; };
  mapHost = hostName: { localHostName ? hostName, system, managedBy, users, ... }:
    let
      mkMatch = options: value: assert options ? ${value} || abort; options.${value};
      systemPrefix = mkMatch {
        nixos = "nixosConfigurations";
        nix-darwin = "darwinConfigurations";
      };
      systemFn = mkMatch {
        nixos = nixpkgs.lib.nixosSystem;
        nix-darwin = nix-darwin.lib.darwinSystem;
      };
      specialArgs = { inherit system flakeInputs hostName localHostName; };
      key = if managedBy == "nix-darwin" then localHostName else hostName;
      hostConfig = {
        name = systemPrefix managedBy;
        value.${key} = systemFn managedBy {
          modules = [
            ../modules/${managedBy}
            ../hosts/shared/${managedBy}.nix
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
    assert lib.map (x: x + 1) [ 1 2 3 ] == [ 2 3 4 ];
    [ hostConfig ] ++ lib.map userConfig users;
in

assert lib.mapAttrs (k: v: v + 1) { a = 1; b = 2; } == { a = 2; b = 3; };
assert lib.foldl' (a: b: a + b) 0 [ 1 2 3 ] == 6;
assert lib.groupBy (x: if x > 2 then "big" else "small") [ 1 2 3 4 ] == { small = [ 1 2 ]; big = [ 3 4 ]; };
assert lib.flatten [ [ 1 2 ] [ 3 ] [ 4 5 ] ] == [ 1 2 3 4 5 ];
assert lib.mapAttrsToList (k: v: v) { a = 1; b = 2; } == [ 1 2 ];

lib.mapAttrs (_: lib.foldl' (a: b: a // b.value) { })
  (lib.groupBy (c: c.name) (lib.flatten (lib.mapAttrsToList mapHost hosts)))
