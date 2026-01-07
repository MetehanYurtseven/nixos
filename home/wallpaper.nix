{ pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      preload = [ settings.wallpaper.path ];
    };
  };

  home.packages = with pkgs; [
    hyprpaper
    rwpspread

    (writeShellScriptBin "set-wallpaper" ''
      set -euo pipefail

      TARGET="''${1:-}"
      WALLPAPER_LINK="${settings.wallpaper.path}"

      if [ -z "$TARGET" ]; then
        echo "Usage: set-wallpaper <path-to-wallpaper>"
        exit 1
      fi

      if [ ! -f "$TARGET" ]; then
        echo "Error: File '$TARGET' not found!"
        exit 1
      fi

      TARGET_ABS="$(realpath "$TARGET")"
      ln -sf "$TARGET_ABS" "$WALLPAPER_LINK"
      rwpspread --backend hyprpaper --image "$WALLPAPER_LINK"

      echo "Wallpaper set: $TARGET_ABS"
    '')
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "rwpspread --daemon --backend hyprpaper --image ${settings.wallpaper.path}"
    ];
  };
}
