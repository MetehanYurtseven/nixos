{ config, pkgs, ... }: {
  imports = [
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/zsh.nix
    ../../home/neovim.nix
    ../../home/kitty.nix
    ../../home/fonts.nix
    ../../home/gtk.nix
    ../../home/waybar.nix
    ../../home/wallpaper.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    # System
    chromium # Internet Browser
    xfce.thunar # File Manager
    kitty # Terminal
    hyprpolkitagent # PolKit Agent for Hyprland

    # Theme
    rose-pine-gtk-theme # GTK Theme

    # Fonts
    nerd-fonts.hack # Hack Nerd Font
    nerd-fonts.mononoki # Mononoki Nerd Font
    nerd-fonts.symbols-only # Symbols Only Nerd Font
    noto-fonts-emoji # Emoji Font

    # General
    code-cursor-fhs # Cursor for VS Code
  ];

  home.stateVersion = "18.09";
}

