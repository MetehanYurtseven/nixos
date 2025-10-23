{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./wifi.nix
    ./boot.nix
    ./networking.nix
    ./hardware.nix
    ./users.nix

    ../../packages.nix
    ../../system/packages.nix
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

  environment.systemPackages = map 
    (name: pkgs.${name}) 
    (builtins.filter 
      (line: line != "" && !(lib.hasPrefix "#" line))
      (lib.splitString "\n" (builtins.readFile ../../packages))
    );

  system.stateVersion = "25.05";
}

