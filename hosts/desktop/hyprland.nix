{ config, pkgs, ... }:

let
  settings = import ../../settings.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = settings.applications.terminal;
      "$fileManager" = settings.applications.fileManager;
      "$launcher" = "vicinae toggle";
      "$browser" = settings.applications.browser;
      "$pass" = "1password";
      "$music" = "youtube-music";
      "$wiki" = "gtk-launch slite";
      "$whatsapp" = "gtk-launch whatsapp";
      "$teams" = "gtk-launch microsoft-teams";
      "$outlook" = "gtk-launch outlook";
      "$ha" = "gtk-launch home-assistant";

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
      	"special:music, on-created-empty:$music"
      	"special:pass, on-created-empty:$pass"
      	"special:wiki, on-created-empty:$wiki"
      	"special:whatsapp, on-created-empty:$whatsapp"
      	"special:teams, on-created-empty:$teams"
      	"special:outlook, on-created-empty:$outlook"
      	"special:ha, on-created-empty:$ha"
      ];

      exec-once = [
      	"waybar &"  # Waybar Menu Bar
        # "vicinae server &"  # Vicinae Launcher
      	"1password --ozone-platform-hint=x11 --silent &"  # 1Password
      	"gsettings set org.gnome.desktop.interface cursor-theme '${settings.cursor.theme}'"  # Fix cursor for GTK apps
      	"gsettings set org.gnome.desktop.interface cursor-size ${toString settings.cursor.size}"  # Fix cursor size for GTK apps
      	"gsettings set org.gnome.desktop.interface icon-theme 'rose-pine'"  # Fix icons for GTK apps
      	"gsettings set org.gnome.desktop.interface gtk-theme 'rose-pine'"  # Fix GTK theme
      ];

      env = [
      	"XDG_CURRENT_DESKTOP,Hyprland"
      	"XCURSOR_THEME,${settings.cursor.theme}"
      	"XCURSOR_SIZE,${toString settings.cursor.size}"
      	"HYPRCURSOR_THEME,${settings.cursor.theme}"
      	"HYPRCURSOR_SIZE,${toString settings.cursor.size}"
      	"GTK_THEME,rose-pine"
      ];

      general =  {
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

      device = {
        name = "logitech-mx-master-3s";
        sensitivity = -1;
      };

      bind = [
        "$mod SHIFT, Q, exit," # Exit Hyprland
        "$mod, Q, killactive," # Kill Active Window
        "$mod, D, togglefloating," # Toggle Floating
        "$mod, E, exec, $fileManager" # File Manager
        "$mod, Return, exec, $terminal" # Terminal
        "$mod, Space, exec, $launcher" # Launcher
        "$mod, B, exec, $browser" # Browser
        "$mod, F, fullscreenstate, 2" # Fullscreen

        "CTRL SHIFT, Space, exec, 1password --quick-access" # 1Password Quick Access
        ", Print, exec, grimblast copysave area ~/pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).jpg" # Screenshots
        "$mod, V, exec, xdg-open vicinae://extensions/vicinae/clipboard/history" # Vicinae Clipboard History
        "$mod, R, exec, xdg-open vicinae://extensions/vicinae/system/run" # Vicinae Run

        "$mod, P, togglespecialworkspace, pass"
        "$mod, M, togglespecialworkspace, music"
        "$mod, N, togglespecialworkspace, wiki"
        "$mod, W, togglespecialworkspace, whatsapp"
        "$mod, T, togglespecialworkspace, teams"
        "$mod, O, togglespecialworkspace, outlook"
        "$mod, A, togglespecialworkspace, ha"

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

      windowrulev2 = [
        "suppressevent maximize, class:.*"

        "float, title:(1Password)"
        "size 70% 70%, title:(1Password)"
        "center, title:(1Password)"
        "stayfocused, title:(Quick Access - 1Password)"

        "float, title:(Volume Control)"
        "size 50% 50%, title:(Volume Control)"
        "center, title:(Volume Control)"

        "float, title:(YouTube Music)"
        "size 70% 70%, title:(YouTube Music)"
        "center, title:(YouTube Music)"

        "float, class:(chrome-teams.microsoft.com__-Default)"
        "size 70% 70%, class:(chrome-teams.microsoft.com__-Default)"
        "center, class:(chrome-teams.microsoft.com__-Default"

        "float, class:(chrome-outlook.office.com__-Default)"
        "size 80% 80%, class:(chrome-outlook.office.com__-Default)"
        "center, class:(chrome-outlook.office.com__-Default)"

        "float, class:(chrome-home.melthrox.de__-Default)"
        "size 63% 70%, class:(chrome-home.melthrox.de__-Default)"
        "center, class:(chrome-home.melthrox.de__-Default)"

        "float, class:(chrome-web.whatsapp.com__-Default)"
        "size 70% 70%, class:(chrome-web.whatsapp.com__-Default)"
        "center, class:(chrome-web.whatsapp.com__-Default)"

        "float, title:(Qalculate!)"
        "size 40% 50%, title:(Qalculate!)"
        "center, title:(Qalculate!)"

        "float, class:(chrome-itsolutions-gg.slite.com__app-Default)"
        "size 80% 80%, class:(chrome-itsolutions-gg.slite.com__app-Default)"
        "center, class:(chrome-itsolutions-gg.slite.com__app-Default)"

        "float, title:(Waypaper)"
        "size 30% 50%, title:(Waypaper)"
        "center, title:(Waypaper)"
      ];
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}

