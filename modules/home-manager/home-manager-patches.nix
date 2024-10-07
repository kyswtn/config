{ config, lib, pkgs, ... }: {
  # Patch home-manager to link spolight-indexable applications.
  # https://github.com/nix-community/home-manager/issues/1341
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    removeDefaultLinkedApps =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf "$HOME/Applications/Home Manager Apps"
      '';
    trampolineApps =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        toDir="$HOME/Applications/HMApps"
        fromDir="${apps}/Applications"
        rm -rf "$toDir"
        mkdir "$toDir"
        (
          cd "$fromDir"
          for app in *.app; do
            /usr/bin/osacompile -o "$toDir/$app" -e "do shell script \"open '$fromDir/$app'\""
            icon="$(/usr/bin/plutil -extract CFBundleIconFile raw "$fromDir/$app/Contents/Info.plist")"
            [[ $icon != *".icns" ]] && icon="$icon.icns"
            mkdir -p "$toDir/$app/Contents/Resources"
            iconPath="$fromDir/$app/Contents/Resources/$icon" 
            cp -f "$iconPath" "$toDir/$app/Contents/Resources/applet.icns"
          done
        )
      '';
  };
}

# The absurd ever drama of just trying to be okay ... and the game gets faster
# and the game gets harder. More gadgets, more screens, more patches and 
# non-stick frying pans and fiber broadband and ultrasonic fucking toothbrushes.
#
# - exurb1a, from "Buddhism is Kinda Out There, Man"
