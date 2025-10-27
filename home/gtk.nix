{ config, pkgs, ... }:
let
  settings = import ../settings.nix;
in
{
  home.pointerCursor = {
    gtk.enable = true;
    name = "BreezeX-RosePine-Linux";
    size = 24;
    package = pkgs.rose-pine-cursor;
  };

  gtk = {
    enable = true;
    
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };

    font = {
      name = settings.appearance.font;
      size = 11;
    };
  };

}

