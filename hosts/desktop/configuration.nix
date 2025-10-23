{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./wifi.nix
    ./boot.nix
    ./networking.nix
    ./hardware.nix
    ./users.nix

    ../../pkgs.nix
    ../../system/console.nix
    ../../system/environment.nix
    ../../system/security.nix
    ../../system/tmpfiles.nix
    ../../system/zsh.nix
    ../../system/neovim.nix
    ../../system/1password.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
  ];

  system.stateVersion = "25.05";
}

