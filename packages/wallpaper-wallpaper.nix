{ pkgs }:
pkgs.writeShellScriptBin "wallpaper-wallpaper" ''
  WALLPAPER_DIR="$HOME/Wallpapers"
  STATE_FILE="$HOME/.cache/wallpaper-state"
  
  mkdir -p "$(dirname "$STATE_FILE")" "$WALLPAPER_DIR"
  
  shopt -s nullglob
  WALLPAPERS=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,JPG,JPEG,PNG})
  shopt -u nullglob
  
  [ ''${#WALLPAPERS[@]} -eq 0 ] && exit 0
  
  IFS=$'\n' WALLPAPERS=($(sort <<<"''${WALLPAPERS[*]}"))
  unset IFS
  
  CURRENT_WALLPAPER=""
  [ -f "$STATE_FILE" ] && CURRENT_WALLPAPER=$(cat "$STATE_FILE")
  
  NEXT_INDEX=0
  for i in "''${!WALLPAPERS[@]}"; do
    if [ "''${WALLPAPERS[$i]}" = "$CURRENT_WALLPAPER" ]; then
      NEXT_INDEX=$(( (i + 1) % ''${#WALLPAPERS[@]} ))
      break
    fi
  done
  
  WALLPAPER="''${WALLPAPERS[$NEXT_INDEX]}"
  echo "$WALLPAPER" > "$STATE_FILE"
  
  ${pkgs.procps}/bin/pkill swaybg 2>/dev/null || true
  ${pkgs.swaybg}/bin/swaybg -i "$WALLPAPER" -m fill &
  disown
''
