flakeInputs@{ nixpkgs, nix-darwin, home-manager, ... }:
{ features ? [ ], hosts }:
let
  inherit (nixpkgs.lib) lists attrsets;

  allFeatures = features;

  mkConfigFromStruct = { prefix, key, fn, config }:
    attrsets.nameValuePair
      prefix
      { "${key}" = fn config; };

  naiveMatch = options: value: attrsets.getAttr
    (if attrsets.hasAttr value options then value else "_")
    options;

  matchSystemManagerPrefix = naiveMatch {
    nixos = "nixosConfigurations";
    nix-darwin = "darwinConfigurations";
  };

  matchSystemManagerFn = naiveMatch {
    nixos = nixpkgs.lib.nixosSystem;
    nix-darwin = nix-darwin.lib.darwinSystem;
  };

  mapHost = hostName: { localHostName ? hostName, system, managed-by, users, selected-features ? null, ... }:
    let
      features = attrsets.genAttrs allFeatures (name:
        if selected-features == null
        then true
        else (lists.elem name selected-features)
      );
      specialArgs = { inherit system flakeInputs features; };
      hostConfig = (mkConfigFromStruct {
        prefix = matchSystemManagerPrefix managed-by;
        # nix-darwin uses LocalHostName instead of HostName
        # https://github.com/LnL7/nix-darwin/pull/676
        key = if managed-by == "nix-darwin" then localHostName else hostName;
        fn = matchSystemManagerFn managed-by;
        config = {
          modules = [
            ../overlays
            ../modules/${managed-by}
            ../hosts/shared/${managed-by}.nix
            ../hosts/${hostName}/configuration.nix
          ];
          specialArgs = specialArgs // { inherit hostName localHostName; };
        };
      });
      mapUserToConfig = username:
        mkConfigFromStruct {
          prefix = "homeConfigurations";
          key = "${username}@${hostName}";
          fn = home-manager.lib.homeManagerConfiguration;
          config = {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              ../overlays
              ../modules/home-manager
              ../users/shared
              ../users/${username}/home.nix
            ];
            extraSpecialArgs = specialArgs // { inherit username; };
          };
        };
    in
    [ hostConfig ] ++ (lists.map mapUserToConfig users);
in
(attrsets.mapAttrs
  (prefix: configs: attrsets.mergeAttrsList configs)
  (lists.groupBy'
    (a: b: a ++ [ b.value ])
    [ ]
    (config: config.name)
    (lists.flatten (attrsets.mapAttrsToList mapHost hosts))))
