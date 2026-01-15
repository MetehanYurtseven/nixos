{ pkgs, settings, ... }:
{
  home.packages = with pkgs; [
    hyprpolkitagent # PolKit Agent for Hyprland
    tts-cli
    mpv
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
      "$terminal" = settings.applications.terminal;
      "$fileManager" = settings.applications.fileManager;
      "$launcher" = "vicinae toggle";
      "$browser" = settings.applications.browser;
      "$pass" = "1password";

      "$base" = "0xff191724";
      "$surface" = "0xff1f1d2e";
      "$overlay" = "0xff26233a";
      "$muted" = "0xff6e6a86";
      "$subtle" = "0xff908caa";
      "$text" = "0xffe0def4";
      "$love" = "0xffeb6f92";
      "$gold" = "0xfff6c177";
      "$rose" = "0xffebbcba";
      "$pine" = "0xff31748f";
      "$foam" = "0xff9ccfd8";
      "$iris" = "0xffc4a7e7";
      "$highlightLow" = "0xff21202e";
      "$highlightMed" = "0xff403d52";
      "$highlightHigh" = "0xff524f67";

      monitorv2 = [
        {
          output = "DP-3";
          mode = "preferred";
          position = "2560x0";
          scale = 1;
          bitdepth = 10;
        }
        {
          output = "DP-4";
          mode = "preferred";
          position = "0x0";
          scale = 1;
          bitdepth = 8;
        }
      ];

      "$mod" = settings.input.modifierKey;

      workspace = [
        "name:󱄅, monitor:DP-4, default:true"
        "1, monitor:DP-3, default:true"
        "2, monitor:DP-3"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-3"
        "6, monitor:DP-3"
        "7, monitor:DP-3"
        "8, monitor:DP-3"
        "9, monitor:DP-3"
        "0, monitor:DP-3"
        "special:pass, on-created-empty:$pass"
      ];

      exec-once = [
        "1password --ozone-platform-hint=x11 --silent &" # 1Password
        "steam -silent &" # Steam
        "gsettings set org.gnome.desktop.interface cursor-theme '${settings.cursor.theme}'" # Fix cursor for GTK apps
        "gsettings set org.gnome.desktop.interface cursor-size ${toString settings.cursor.size}" # Fix cursor size for GTK apps
        "gsettings set org.gnome.desktop.interface icon-theme 'rose-pine'" # Fix icons for GTK apps
        "gsettings set org.gnome.desktop.interface gtk-theme 'rose-pine'" # Fix GTK theme
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XCURSOR_THEME,${settings.cursor.theme}"
        "XCURSOR_SIZE,${toString settings.cursor.size}"
        "HYPRCURSOR_THEME,${settings.cursor.theme}"
        "HYPRCURSOR_SIZE,${toString settings.cursor.size}"
        "GTK_THEME,rose-pine"
      ];

      general = {
        gaps_in = 5;
        gaps_out = "10,20,20,20";

        border_size = 1;

        "col.active_border" = "$rose $pine $love $iris 90deg";
        "col.inactive_border" = "$muted";

        resize_on_border = false;
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        active_opacity = 1;
        inactive_opacity = 0.8;

        blur = {
          enabled = true;
          size = 10;
          passes = 3;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 5, default"
          "fade, 1, 5, default"
          "workspaces, 1, 5, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = settings.input.keyboardLayout;
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        sensitivity = settings.input.mouseSensitivity;
        touchpad.natural_scroll = false;
      };

      bind = [
        "$mod SHIFT, Q, exit," # Exit Hyprland
        "$mod, Q, killactive," # Kill Active Window
        "$mod, D, togglefloating," # Toggle Floating
        "$mod, F, fullscreenstate, 2" # Fullscreen

        "$mod, E, exec, $fileManager" # File Manager
        "$mod, Return, exec, $terminal" # Terminal
        "$mod, Space, exec, $launcher" # Launcher
        "$mod, B, exec, $browser" # Browser

        "CTRL SHIFT, Space, exec, 1password --quick-access" # 1Password Quick Access
        ", Print, exec, grimblast copysave area ~/pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).jpg" # Screenshots
        "$mod, V, exec, xdg-open vicinae://extensions/vicinae/clipboard/history" # Vicinae Clipboard History
        "$mod, R, exec, xdg-open vicinae://extensions/vicinae/system/run" # Vicinae Run
        "$mod, Y, exec, hyprvoice toggle"
        "$mod, T, exec, sh -c 'wl-paste | tts-cli -o /dev/stdout | mpv -'"

        "$mod, P, togglespecialworkspace, pass" # Toggle 1Password Workspace

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod CTRL, h, movewindow, l"
        "$mod CTRL, l, movewindow, r"
        "$mod CTRL, k, movewindow, u"
        "$mod CTRL, j, movewindow, d"

        "$mod SHIFT, h, resizeactive, -100 0"
        "$mod SHIFT, l, resizeactive, 100 0"
        "$mod SHIFT, k, resizeactive, 0 -100"
        "$mod SHIFT, j, resizeactive, 0 100"

        "$mod, code:49, workspace, name:󱄅"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, TAB, workspace, e+1"
        "$mod SHIFT, TAB, workspace, e-1"
        ", mouse:275, workspace, e+1"
        ", mouse:276, workspace, e-1"

        "$mod SHIFT, code:49, movetoworkspace, name:󱄅"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_up, workspace, e+1"
        "$mod, mouse_down, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrule = [
        "suppress_event maximize, match:class .*"
        "float on, size (monitor_w*0.7) (monitor_h*0.7), center on, match:title (1Password)"
        "float on, size (monitor_w*0) (monitor_h*0), center on, match:title (Qalculate!)"
        "float on, size (monitor_w*0.3) (monitor_h*0.5), center on, match:title (Bluetooth Devices)"
        # "stay_focused on, match:title (Quick Access - 1Password)"
      ];
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GOPATH = "$HOME/.cache/go";
    GOBIN = "$HOME/.local/bin";
  };
}
