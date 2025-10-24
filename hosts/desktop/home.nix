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
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    kitty
    xfce.thunar
    chromium
    hyprpolkitagent
    nerd-fonts.hack
    nerd-fonts.mononoki
    nerd-fonts.symbols-only
    noto-fonts-emoji
    code-cursor-fhs
    nodejs_24
  ];

  home.stateVersion = "18.09";
}

