{ pkgs, ... }:

{
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = false;
      load = false;
    };
  };

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    gcr
  ];
}
