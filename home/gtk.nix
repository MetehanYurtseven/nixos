{ config, pkgs, ... }:
let
  settings = import ../settings.nix;
in
{
  home.pointerCursor = {
    gtk.enable = true;
    name = settings.cursor.theme;
    size = settings.cursor.size;
    package = pkgs.${settings.cursor.package};
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
      size = 12;
    };
  };

}