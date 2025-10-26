{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  services.hyprpaper = {
    enable = true;
    
    settings = {
      ipc = "on"; # IPC als String aktivieren für dynamische Wallpaper-Änderungen
      splash = false; # Hyprland Splash Screen deaktivieren
      preload = [ settings.wallpaper.path ]; # Wallpaper vorladen für rwpspread
    };
  };

  home.packages = with pkgs; [
    hyprpaper # Benötigt für rwpspread (muss im PATH sein)
    rwpspread # Multi-Monitor Wallpaper Spanning Tool
    
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
      
      # Preload und span mit rwpspread
      echo "Setting wallpaper: $WALLPAPER_PATH"
      hyprctl hyprpaper preload "$WALLPAPER_PATH"
      ${pkgs.rwpspread}/bin/rwpspread --image "$WALLPAPER_PATH"
      
      echo "Wallpaper successfully set!"
    '')
  ];

  # Hyprland Autostart für Wallpaper
  # rwpspread im Daemon-Mode: Automatisches Spanning + Monitor-Hotplug-Support
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "rwpspread --daemon --backend hyprpaper --image ${settings.wallpaper.path}"
    ];
  };
}

