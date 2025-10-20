{ config, pkgs, ... }: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}/desktop";
    download = "${config.home.homeDirectory}/downloads";

    documents = null;
    music = null;
    pictures = null;
    publicShare = null;
    templates = null;
    videos = null;
  };

  home.packages = with pkgs; [
    kitty # Terminal
    xfce.thunar # File Manager
    chromium # Internet Browser
    hyprpolkitagent # Authentication Agent
    nerd-fonts.hack # Nerd Font: Hack
    nerd-fonts.mononoki # Nerd Font: Mononoki
    code-cursor-fhs # Cursor AI
    nodejs_24 # Node.js
  ];

  programs = {
    git = {
      enable = true;
      settings.user.name = "Metehan Yurtseven";
      settings.user.email = "metehan.yurtseven@itsolutions-gg.de";
      settings.safe.directory = "/etc/nixos";
    };

    zsh = {
      enable = true;

      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls = "lsd";
        sl = "ls";
        l = "ls";
        ll = "l -l";
        la = "l -lA";
        lt = "ll --tree --depth 3";
        tree = "ls --tree";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "sudo"
          "git"
          "fzf"
          "python"
        ];
        theme = "dieter";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
      ];

      extraConfig = ''
	      " Use 2 spaces as tab
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set softtabstop=2
      '';
    };

    kitty = {
      enable = true;
      settings = {
        font_family = "Mononoki Nerd Font";
        bold_font = "Mononoki Nerd Font Heavy";
        italic_font = "Mononoki Nerd Font Italic";
        bold_italic_font = "Mononoki Nerd Font Heavy Italic";

        font_size = "12.0";
      };
    };
  };

  fonts.fontconfig.enable = true;
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$launcher" = "vicinae toggle"; # NOT INSTALLED
      "$browser" = "chromium --disable-features=WaylandWpColorManagerV1";
      "$pass" = "1password";
      "$music" = "youtube-music"; # NOT INSTALLED
      "$wiki" = "gtk-launch slite"; # NOT INSTALLED
      "$whatsapp" = "gtk-launch whatsapp"; # NOT INSTALLED
      "$teams" = "gtk-launch microsoft-teams"; # NOT INSTALLED
      "$outlook" = "gtk-launch outlook"; # NOT INSTALLED
      "$ha" = "gtk-launch home-assistant"; # NOT INSTALLED 

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
          output = "DP-5";
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

      "$mod" = "SUPER";

      workspace = [
      	"name:home, monitor:DP-4, default:true"
      	"0, monitor:DP-5, default:true"
      	"1, monitor:DP-5"
      	"2, monitor:DP-5"
      	"3, monitor:DP-5"
      	"4, monitor:DP-5"
      	"5, monitor:DP-5"
      	"6, monitor:DP-5"
      	"7, monitor:DP-5"
      	"8, monitor:DP-5"
      	"9, monitor:DP-5"
      	"special:music, on-created-empty:$music"
      	"special:pass, on-created-empty:$pass"
      	"special:wiki, on-created-empty:$wiki"
      	"special:whatsapp, on-created-empty:$whatsapp"
      	"special:teams, on-created-empty:$teams"
      	"special:outlook, on-created-empty:$outlook"
      	"special:ha, on-created-empty:$ha"
      ];

      # Autostart
      exec-once = [
      	"1password --ozone-platform-hint=x11 --silent &" # Password Manager (X11 mode für bessere Prompt-Darstellung)
        # "waybar" # Menu Bar # TODO
        # "uxplay" # AirPlay # TODO
        # "solaar -w hide -b symbolic" # Logitech Unifying Receiver # TODO
      	# "vicinae server" # Application Launcher # TODO
      	# "thunar --daemon" # File Manager Daemon # TODO
      ];

      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
      	"XDG_CURRENT_DESKTOP,Hyprland"
      	"XCURSOR_SIZE,24"
      	"HYPRCURSOR_SIZE,24"
      ];

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general =  {
        gaps_in = 5;
        gaps_out = "10,20,20,20";

        border_size = 1;

        "col.active_border" = "$rose $pine $love $iris 90deg";
        "col.inactive_border" = "$muted";

        resize_on_border = false; # Set to true enable resizing windows by clicking and dragging on borders and gaps
        allow_tearing = false; # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1;
          inactive_opacity = 0.8;

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
              enabled = true;
              size = 10;
              passes = 3;
              
              vibrancy = 0.1696;
          };
      };

      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
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

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
          new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = { 
          force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };

      input = {
        kb_layout = "de";
        kb_options = "ctrl:nocaps";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad.natural_scroll = false;
      };

      device = {
        name = "logitech-mx-master-3s";
        sensitivity = -1;
      };

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod SHIFT, Q, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, D, togglefloating,"
        "$mod, Space, exec, $launcher"
        "$mod, B, exec, $browser"
        "$mod, F, fullscreenstate, 2"
        "CTRL SHIFT, Space, exec, 1password --quick-access"
        "$mod, R, exec, wofi --show run"
        "$mod SHIFT, P, exec, gtk-launch ftwa-perplexity"

        # Special Workplaces
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

        # Switch workspaces with mainMod + [0-9]
        "$mod, code:49, workspace, name:󰣇"
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

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, code:49, movetoworkspace, name:󰣇"
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

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_up, workspace, e+1"
        "$mod, mouse_down, workspace, e-1"


      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      # Windows Rules
      windowrulev2 = [
        "suppressevent maximize, class:.* # You'll probably like this."

        # 1password
        "float, title:(1Password)"
        "size 70% 70%, title:(1Password)"
        "center, title:(1Password)"

        # pavucontrol
        "float, title:(Volume Control)"
        "size 50% 50%, title:(Volume Control)"
        "center, title:(Volume Control)"

        # Youtube Music
        "float, title:(YouTube Music)"
        "size 70% 70%, title:(YouTube Music)"
        "center, title:(YouTube Music)"

        # Microsoft Teams
        "float, class:(chrome-teams.microsoft.com__-Default)"
        "size 70% 70%, class:(chrome-teams.microsoft.com__-Default)"
        "center, class:(chrome-teams.microsoft.com__-Default"

        # Microsoft Outlook
        "float, class:(chrome-outlook.office.com__-Default)"
        "size 80% 80%, class:(chrome-outlook.office.com__-Default)"
        "center, class:(chrome-outlook.office.com__-Default)"

        # Home Assistant
        "float, class:(chrome-home.melthrox.de__-Default)"
        "size 63% 70%, class:(chrome-home.melthrox.de__-Default)"
        "center, class:(chrome-home.melthrox.de__-Default)"

        # WhatsApp
        "float, class:(chrome-web.whatsapp.com__-Default)"
        "size 70% 70%, class:(chrome-web.whatsapp.com__-Default)"
        "center, class:(chrome-web.whatsapp.com__-Default)"

        # Qalculate
        "float, title:(Qalculate!)"
        "size 40% 50%, title:(Qalculate!)"
        "center, title:(Qalculate!)"

        # Slite
        "float, class:(chrome-itsolutions-gg.slite.com__app-Default)"
        "size 80% 80%, class:(chrome-itsolutions-gg.slite.com__app-Default)"
        "center, class:(chrome-itsolutions-gg.slite.com__app-Default)"

        # Waypaper
        "float, title:(Waypaper)"
        "size 30% 50%, title:(Waypaper)"
        "center, title:(Waypaper)"
      ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.stateVersion = "18.09";
}
