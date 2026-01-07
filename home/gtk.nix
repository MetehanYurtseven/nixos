{ pkgs, ... }:
let
  settings = import ../settings.nix;

  # Rose Pine colors applied to adw-gtk3-dark base theme
  # adw-gtk3 provides complete widget styling, we just override colors
  rosePineColors = ''
    /* Rosé Pine color overrides for adw-gtk3 */
    /* Source: https://rosepinetheme.com/palette */

    @define-color accent_bg_color #c4a7e7;
    @define-color accent_fg_color #191724;
    @define-color accent_color #c4a7e7;

    @define-color destructive_bg_color #eb6f92;
    @define-color destructive_fg_color #191724;
    @define-color destructive_color #eb6f92;

    @define-color success_bg_color #9ccfd8;
    @define-color success_fg_color #191724;
    @define-color success_color #9ccfd8;

    @define-color warning_bg_color #f6c177;
    @define-color warning_fg_color #191724;
    @define-color warning_color #f6c177;

    @define-color error_bg_color #eb6f92;
    @define-color error_fg_color #191724;
    @define-color error_color #eb6f92;

    @define-color window_bg_color #191724;
    @define-color window_fg_color #e0def4;

    @define-color view_bg_color #1f1d2e;
    @define-color view_fg_color #e0def4;

    @define-color headerbar_bg_color #26233a;
    @define-color headerbar_fg_color #e0def4;
    @define-color headerbar_backdrop_color #191724;
    @define-color headerbar_shade_color rgba(0,0,0,0.36);
    @define-color headerbar_darker_shade_color rgba(0,0,0,0.9);

    @define-color sidebar_bg_color #1f1d2e;
    @define-color sidebar_fg_color #e0def4;
    @define-color sidebar_backdrop_color #191724;
    @define-color sidebar_shade_color rgba(0,0,0,0.25);

    @define-color secondary_sidebar_bg_color #191724;
    @define-color secondary_sidebar_fg_color #e0def4;
    @define-color secondary_sidebar_backdrop_color #191724;
    @define-color secondary_sidebar_shade_color rgba(0,0,0,0.25);

    @define-color card_bg_color #26233a;
    @define-color card_fg_color #e0def4;
    @define-color card_shade_color rgba(0,0,0,0.36);

    @define-color dialog_bg_color #26233a;
    @define-color dialog_fg_color #e0def4;

    @define-color popover_bg_color #26233a;
    @define-color popover_fg_color #e0def4;
    @define-color popover_shade_color rgba(0,0,0,0.25);

    @define-color thumbnail_bg_color #1f1d2e;
    @define-color thumbnail_fg_color #e0def4;

    @define-color shade_color rgba(0,0,0,0.25);
    @define-color scrollbar_outline_color #191724;

    @define-color blue_1 #9ccfd8;
    @define-color blue_2 #9ccfd8;
    @define-color blue_3 #31748f;
    @define-color blue_4 #31748f;
    @define-color blue_5 #31748f;

    @define-color green_1 #9ccfd8;
    @define-color green_2 #9ccfd8;
    @define-color green_3 #9ccfd8;
    @define-color green_4 #31748f;
    @define-color green_5 #31748f;

    @define-color yellow_1 #f6c177;
    @define-color yellow_2 #f6c177;
    @define-color yellow_3 #f6c177;
    @define-color yellow_4 #f6c177;
    @define-color yellow_5 #f6c177;

    @define-color orange_1 #ebbcba;
    @define-color orange_2 #ebbcba;
    @define-color orange_3 #ebbcba;
    @define-color orange_4 #ebbcba;
    @define-color orange_5 #ebbcba;

    @define-color red_1 #eb6f92;
    @define-color red_2 #eb6f92;
    @define-color red_3 #eb6f92;
    @define-color red_4 #eb6f92;
    @define-color red_5 #eb6f92;

    @define-color purple_1 #c4a7e7;
    @define-color purple_2 #c4a7e7;
    @define-color purple_3 #c4a7e7;
    @define-color purple_4 #c4a7e7;
    @define-color purple_5 #c4a7e7;

    @define-color brown_1 #908caa;
    @define-color brown_2 #6e6a86;
    @define-color brown_3 #524f67;
    @define-color brown_4 #403d52;
    @define-color brown_5 #26233a;

    @define-color light_1 #e0def4;
    @define-color light_2 #e0def4;
    @define-color light_3 #908caa;
    @define-color light_4 #6e6a86;
    @define-color light_5 #524f67;

    @define-color dark_1 #524f67;
    @define-color dark_2 #403d52;
    @define-color dark_3 #26233a;
    @define-color dark_4 #1f1d2e;
    @define-color dark_5 #191724;
  '';
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

    # adw-gtk3-dark provides complete widget styling
    # We override colors with rose-pine palette
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };

    font = {
      name = settings.appearance.displayFont;
      size = 12;
    };

    # Override adw-gtk3-dark colors with rose-pine
    gtk4.extraCss = rosePineColors;
    gtk3.extraCss = rosePineColors;
  };

}
