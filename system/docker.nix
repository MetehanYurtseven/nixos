{ config, pkgs, ... }:

let
  settings = import ../settings.nix;
in
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.${settings.user.username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}

