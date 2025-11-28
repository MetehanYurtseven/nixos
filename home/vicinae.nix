{ config, lib, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      font = {
        normal = settings.appearance.displayFont;
        size = 12;
      };
      window = {
        csd = true;
        opacity = 0.98;
        rounding = 10;
      };
      keybinding = "default";
      theme.name = "rose-pine";
      faviconService = "twenty";
      closeOnFocusLoss = false;
      rootSearch.searchFiles = true;
    };
  };
}

