{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./pkgs.nix
    ./wifi.nix
    ./system/1password.nix
    ./system/boot.nix
    ./system/networking.nix
    ./system/console.nix
    ./system/hardware.nix
    ./system/security.nix
    ./system/tmpfiles.nix
    ./system/users.nix
    ./system/zsh.nix
    ./system/neovim.nix
    ./system/environment.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
