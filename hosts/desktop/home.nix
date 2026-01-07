{ pkgs, ... }:
{
  imports = [
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/kitty.nix
    ../../home/ghostty.nix
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
    nemo-with-extensions # File Manager mit Extensions
    jq # JSON processor
    libnotify # Notifications
    wl-clipboard # Clipboard für Wayland
    qalculate-gtk # Calculator

    # Theme
    rose-pine-gtk-theme # GTK Theme
    rose-pine-icon-theme # Icon Theme
    rose-pine-cursor # Cursor Theme

    # Fonts
    nerd-fonts.hack # Hack Nerd Font
    nerd-fonts.mononoki # Mononoki Nerd Font
    nerd-fonts.symbols-only # Symbols Only Nerd Font
    noto-fonts-color-emoji # Emoji Font
    sf-mono-nerd-font # SF Mono Nerd Font (monospaced)
    sf-pro-nerd-font # SF Pro Nerd Font (proportional)

    # Screenshots
    grim # Screenshot functionality
    slurp # Region selection
    grimblast # Hyprland screenshot helper

    # Gaming
    wineWowPackages.stagingFull
    winetricks
  ];

  home.stateVersion = "18.09";
}
