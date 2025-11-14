{ config, lib, pkgs, aish, ... }:

let
  customPackages = [
    "copilot-api"
  ];

  complexPackages = map 
    (name: pkgs.callPackage ../../packages/${name}.nix { })
    customPackages;
in
{
  imports = [
    ./hardware-configuration.nix
    ./wifi.nix
    ./boot.nix
    ./networking.nix
    ./hardware.nix
    ./users.nix
    ./steam.nix

    ../../system/packages.nix
    ../../system/console.nix
    ../../system/environment.nix
    ../../system/security.nix
    ../../system/tmpfiles.nix
    ../../system/xonsh.nix
    ../../system/direnv.nix
    ../../system/neovim.nix
    ../../system/1password.nix
    ../../system/audio.nix
    ../../system/ly.nix
    ../../extra-packages.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets."wireguard/private_key" = { };
    secrets."wireguard/preshared_key" = { };
  };

  services.preload.enable = true; # preload increases performence while working up to 55%

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  environment.systemPackages = complexPackages ++ [
    aish.packages.x86_64-linux.default
  ];

  system.stateVersion = "25.05";
}

