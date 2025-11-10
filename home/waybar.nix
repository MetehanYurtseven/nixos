{ config, pkgs, waybar-nixos-updates, ... }: {
  imports = [ waybar-nixos-updates.homeManagerModules.default ];
  
  programs.waybar-nixos-updates = {
    enable = true;
    nixosConfigPath = "/etc/nixos";
  };

  programs.waybar = {
    enable = true;
    
    settings = [{
      layer = "top";
      position = "top";
      height = 24;
      
      modules-left = ["hyprland/workspaces" "tray"];
      # modules-center = ["hyprland/window"];
      modules-right = ["custom/nix-updates" "memory" "cpu" "pulseaudio" "network" "clock"];
      
      "hyprland/workspaces" = {
        active-only = false;
        special-visible-only = true;
      };
      
      "hyprland/window" = {};
      
      tray = {
        spacing = 10;
      };
      
      clock = {
        interval = 1;
        format = "{:%d.%m.%Y %H:%M:%S}";
      };
      
      memory = {
        interval = 1;
        format = "  {used:0.1f}G/{total:0.1f}G";
        on-click = "kitty htop --sort-key=PERCENT_MEM";
      };

      cpu = {
        interval = 1;
        format = "  {usage}%";
        on-click = "kitty htop --sort-key=PERCENT_CPU";
      };
      
      network = {
        format-wifi = "  {ipaddr}";
        format-ethernet = "  {ipaddr}";
        format-disconnected = "  Disconnected";
      };
      
      pulseaudio = {
        scroll-step = 5;
        format = "{icon}  {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = "";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pwvucontrol";
      };
      
      "custom/nix-updates" = config.programs.waybar-nixos-updates.waybarConfig;
    }];
    
    style = ''
      @define-color base            #191724;
      @define-color surface         #1f1d2e;
      @define-color overlay         #26233a;
      
      @define-color muted           #6e6a86;
      @define-color subtle          #908caa;
      @define-color text            #e0def4;
      
      @define-color love            #eb6f92;
      @define-color gold            #f6c177;
      @define-color rose            #ebbcba;
      @define-color pine            #31748f;
      @define-color foam            #9ccfd8;
      @define-color iris            #c4a7e7;
      
      @define-color highlightLow    #21202e;
      @define-color highlightMed    #403d52;
      @define-color highlightHigh   #524f67;
      
      * {
        border: none;
        border-radius: 0;
        font-family: "Mononoki Nerd Font";
        font-size: 15px;
        min-height: 0;
      }
      
      window#waybar {
        background: transparent;
      }
      
      #clock, #cpu, #memory, #network, #pulseaudio, #tray, #workspaces, #window, #custom-nix-updates {
        background: rgba(25, 23, 36, 0.8);
        border: 1px solid @muted;
        padding: 4px 10px;
        margin: 5px 5px;
        margin-top: 10px;
        border-radius: 10px;
        color: @text;
      }
      
      #workspaces {
        margin-left: 20px;
        padding: 4px 0px;
      }
      
      #workspaces button {
        color: @muted;
      }
      
      #workspaces button.active {
        color: @text;
      }
      
      #clock {
        margin-right: 20px;
      }
      
      @keyframes blink {
        to {
          background-color: @iris;
          color: black;
        }
      }
    '';
  };
  
  # pwvucontrol wird über system/audio.nix installiert
  # Hier können zusätzliche Audio-Tools hinzugefügt werden
  home.packages = with pkgs; [
    # Audio-Tools sind bereits im System verfügbar
  ];
}

