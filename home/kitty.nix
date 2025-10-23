{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Mononoki Nerd Font";
      bold_font = "Mononoki Nerd Font Heavy";
      italic_font = "Mononoki Nerd Font Italic";
      bold_italic_font = "Mononoki Nerd Font Heavy Italic";

      font_size = "12.0";
    };
  };
}

