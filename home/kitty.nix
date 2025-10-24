{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = settings.appearance.font;
      bold_font = "${settings.appearance.font} Heavy";
      italic_font = "${settings.appearance.font} Italic";
      bold_italic_font = "${settings.appearance.font} Heavy Italic";

      font_size = "12.0";
    };
  };
}

