{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  # Wallpaper-Management Pakete und Helper-Script
  home.packages = with pkgs; [
    # Wallpaper Tools
    hyprpaper    # Wayland Wallpaper Utility für Hyprland
    rwpspread    # Multi-Monitor Wallpaper Spanning Tool
    
    # Helper Script für manuelles Wallpaper-Setzen
    (writeShellScriptBin "set-wallpaper" ''
      #!/usr/bin/env bash
      set -euo pipefail
      
      WALLPAPER_PATH="''${1:-}"
      
      if [ -z "$WALLPAPER_PATH" ]; then
        echo "Usage: set-wallpaper <path-to-wallpaper>"
        echo "Example: set-wallpaper ~/Pictures/wallpaper.jpg"
        exit 1
      fi
      
      if [ ! -f "$WALLPAPER_PATH" ]; then
        echo "Error: File '$WALLPAPER_PATH' not found!"
        exit 1
      fi
      
      # Prüfe ob hyprpaper läuft
      if ! pgrep -x "hyprpaper" > /dev/null; then
        echo "Starting hyprpaper..."
        ${hyprpaper}/bin/hyprpaper &
        sleep 2
      fi
      
      # Setze Wallpaper mit rwpspread (automatisches Spanning)
      echo "Setting wallpaper: $WALLPAPER_PATH"
      ${rwpspread}/bin/rwpspread -w "$WALLPAPER_PATH"
      
      echo "Wallpaper successfully set!"
    '')
  ];

  # Hyprpaper Konfiguration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    # IPC aktivieren für dynamische Wallpaper-Änderungen
    # Ermöglicht rwpspread die Kommunikation mit hyprpaper
    ipc = on
    
    # Hyprland Splash Screen deaktivieren
    splash = false
    
    # Optional: Splash Offset (falls splash = true)
    # splash_offset = 2.0
    
    # Optional: Splash Color (falls splash = true)  
    # splash_color = 0x55ffffff
  '';

  # Hyprland Autostart für Wallpaper
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper &"
      "sleep 2 && rwpspread -w ${settings.wallpaper.path}"
    ];
  };
}

