{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  programs.kitty = {
    enable = true;

    # Fonts
    settings = {
      font_family = settings.appearance.font;
      bold_font = "${settings.appearance.font} Heavy";
      italic_font = "${settings.appearance.font} Italic";
      bold_italic_font = "${settings.appearance.font} Heavy Italic";
      font_size = 12;

      # Cursor
      cursor_shape = "underline";

      # Scrollback
      scrollback_lines = 1000000;

      # Mouse
      url_style = "curly";

      # Performance
      input_delay = 0;

      # Window layout
      enabled_layouts = "splits,stack";

      # Advanced
      allow_remote_control = "socket";
      shell_integration = "enabled";
      listen_on = "unix:/tmp/kitty";
      term = "xterm-256color";

      # Theme: Rosé Pine
      foreground = "#e0def4";
      background = "#191724";
      selection_foreground = "#e0def4";
      selection_background = "#403d52";

      cursor = "#524f67";
      cursor_text_color = "#e0def4";

      url_color = "#c4a7e7";

      active_tab_foreground = "#e0def4";
      active_tab_background = "#26233a";
      inactive_tab_foreground = "#6e6a86";
      inactive_tab_background = "#191724";

      # Black
      color0 = "#26233a";
      color8 = "#6e6a86";

      # Red
      color1 = "#eb6f92";
      color9 = "#eb6f92";

      # Green
      color2 = "#31748f";
      color10 = "#31748f";

      # Yellow
      color3 = "#f6c177";
      color11 = "#f6c177";

      # Blue
      color4 = "#9ccfd8";
      color12 = "#9ccfd8";

      # Magenta
      color5 = "#c4a7e7";
      color13 = "#c4a7e7";

      # Cyan
      color6 = "#ebbcba";
      color14 = "#ebbcba";

      # White
      color7 = "#e0def4";
      color15 = "#e0def4";
    };

    extraConfig = ''
      # kitty_mod definition (ctrl+shift)
      kitty_mod ctrl+shift
      
      # Clear all default shortcuts FIRST
      clear_all_shortcuts yes

      # Window splits
      map ctrl+e launch --location=vsplit --cwd=current
      map ctrl+o launch --location=hsplit --cwd=current
      map ctrl+enter launch --location=hsplit --cwd=current
      map ctrl+h previous_window
      map ctrl+l next_window

      # Clipboard
      map kitty_mod+c copy_to_clipboard
      map kitty_mod+v paste_from_clipboard
      map shift+insert paste_from_selection

      # Scrolling
      map kitty_mod+k scroll_line_up
      map kitty_mod+j scroll_line_down
      map kitty_mod+u scroll_page_up
      map kitty_mod+d scroll_page_down
      map ctrl+home scroll_home
      map ctrl+end scroll_end

      # Window management
      map kitty_mod+n new_os_window

      # Tab management
      map kitty_mod+right next_tab
      map kitty_mod+left previous_tab
      map kitty_mod+t new_tab
      map kitty_mod+q close_tab
      map kitty_mod+. move_tab_forward
      map kitty_mod+, move_tab_backward
      map kitty_mod+alt+t set_tab_title

      # Layout management
      map kitty_mod+l next_layout

      # Font sizes
      map kitty_mod+equal change_font_size all +2.0
      map kitty_mod+minus change_font_size all -2.0
      map kitty_mod+backspace change_font_size all 0

      # Hints kitten
      map kitty_mod+i kitten hints
      map kitty_mod+p>f kitten hints --type path --program -
      map kitty_mod+p>shift+f kitten hints --type path
      map kitty_mod+p>l kitten hints --type line --program -
      map kitty_mod+p>w kitten hints --type word --program -
      map kitty_mod+p>h kitten hints --type hash --program -
      map kitty_mod+p>n kitten hints --type linenum
      map kitty_mod+p>y kitten hints --type hyperlink

      # Miscellaneous
      map kitty_mod+a>m set_background_opacity +0.1
      map kitty_mod+a>l set_background_opacity -0.1
      map kitty_mod+a>1 set_background_opacity 1
      map kitty_mod+a>d set_background_opacity default
      map kitty_mod+delete clear_terminal reset active

      # kitty-scrollback.nvim action alias
      action_alias kitty_scrollback_nvim kitten /home/melthrox/.local/share/nvim/plugged/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
      
      # kitty-scrollback.nvim shortcuts
      map kitty_mod+h kitty_scrollback_nvim
      map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
      
      # Mouse mapping for kitty-scrollback.nvim
      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    '';
  };
}
