{ config, pkgs, ... }: {
  imports = [
    ../../home/xdg.nix
    ../../home/git.nix
    # ../../home/zsh.nix
    ../../home/neovim.nix
    ../../home/kitty.nix
    ../../home/fonts.nix
    ../../home/gtk.nix
    ../../home/waybar.nix
    ../../home/wallpaper.nix
    ../../home/hypridle.nix
    ../../home/chromium.nix
    ../../home/vicinae.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    # System
    nemo # File Manager
    jq # JSON processor
    libnotify # Notifications
    wl-clipboard # Clipboard für Wayland

    # Theme
    rose-pine-gtk-theme # GTK Theme
    rose-pine-icon-theme # Icon Theme
    rose-pine-cursor # Cursor Theme

    # Fonts
    nerd-fonts.hack # Hack Nerd Font
    nerd-fonts.mononoki # Mononoki Nerd Font
    nerd-fonts.symbols-only # Symbols Only Nerd Font
    noto-fonts-color-emoji # Emoji Font

    # Screenshots
    grim # Screenshot functionality
    slurp # Region selection
    grimblast # Hyprland screenshot helper

    # General
    code-cursor-fhs # Cursor for VS Code
  ];

  home.stateVersion = "18.09";
}

