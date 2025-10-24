{ config, pkgs, ... }: {
  imports = [
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/zsh.nix
    ../../home/neovim.nix
    ../../home/kitty.nix
    ../../home/fonts.nix
    ../../home/cursor.nix
    ../../home/waybar.nix
    ../../home/wallpaper.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    # System
    kitty
    xfce.thunar
    hyprpolkitagent

    # Fonts
    nerd-fonts.hack
    nerd-fonts.mononoki
    nerd-fonts.symbols-only
    noto-fonts-emoji

    # General
    nodejs_24
    code-cursor-fhs
    chromium
  ];

  home.stateVersion = "18.09";
}

