{ config, lib, pkgs, ... }:

let
  customPackages = [
    "copilot-api"
  ];

  simplePackages = map 
    (name: pkgs.${name}) 
    (builtins.filter 
      (line: line != "" && !(lib.hasPrefix "#" line))
      (lib.splitString "\n" (builtins.readFile ../../pkgs))
    );

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
    ../../system/zsh.nix
    ../../system/neovim.nix
    ../../system/1password.nix
    ../../system/audio.nix
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

  environment.systemPackages = simplePackages ++ complexPackages;

  system.stateVersion = "25.05";
}

