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

    # Keyboard shortcuts
    keybindings = {
      # Window splits
      "ctrl+e" = "launch --location=vsplit --cwd=current";
      "ctrl+o" = "launch --location=hsplit --cwd=current";
      "ctrl+enter" = "launch --location=hsplit --cwd=current";
      "ctrl+h" = "previous_window";
      "ctrl+l" = "next_window";

      # Clipboard
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_selection";

      # Scrolling
      "kitty_mod+k" = "scroll_line_up";
      "kitty_mod+j" = "scroll_line_down";
      "kitty_mod+u" = "scroll_page_up";
      "kitty_mod+d" = "scroll_page_down";
      "ctrl+home" = "scroll_home";
      "ctrl+end" = "scroll_end";

      # Window management
      "kitty_mod+n" = "new_os_window";

      # Tab management
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";
      "kitty_mod+q" = "close_tab";
      "kitty_mod+." = "move_tab_forward";
      "kitty_mod+," = "move_tab_backward";
      "kitty_mod+alt+t" = "set_tab_title";

      # Layout management
      "kitty_mod+l" = "next_layout";
      "kitty_mod+t" = "goto_layout tall";
      "kitty_mod+s" = "goto_layout stack";

      # Font sizes
      "kitty_mod+equal" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+backspace" = "change_font_size all 0";

      # Hints kitten
      "kitty_mod+i" = "kitten hints";
      "kitty_mod+p>f" = "kitten hints --type path --program -";
      "kitty_mod+p>shift+f" = "kitten hints --type path";
      "kitty_mod+p>l" = "kitten hints --type line --program -";
      "kitty_mod+p>w" = "kitten hints --type word --program -";
      "kitty_mod+p>h" = "kitten hints --type hash --program -";
      "kitty_mod+p>n" = "kitten hints --type linenum";
      "kitty_mod+p>y" = "kitten hints --type hyperlink";

      # Miscellaneous
      "kitty_mod+a>m" = "set_background_opacity +0.1";
      "kitty_mod+a>l" = "set_background_opacity -0.1";
      "kitty_mod+a>1" = "set_background_opacity 1";
      "kitty_mod+a>d" = "set_background_opacity default";
      "kitty_mod+delete" = "clear_terminal reset active";

      # kitty-scrollback.nvim
      "kitty_mod+h" = "kitty_scrollback_nvim";
      "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };

    extraConfig = ''
      # kitty_mod definition (ctrl+shift)
      kitty_mod ctrl+shift
      
      # Clear all default shortcuts
      clear_all_shortcuts yes

      # kitty-scrollback.nvim action alias
      action_alias kitty_scrollback_nvim kitten /home/melthrox/.local/share/nvim/plugged/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
      
      # Mouse mapping for kitty-scrollback.nvim
      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    '';
  };
}
